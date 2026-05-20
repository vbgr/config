local M = {}

local namespace = vim.api.nvim_create_namespace("config.fzsearch")
local match_hl_group = "ConfigFzsearchMatch"

local defaults = {
  context_chars = 20,
  max_buffer_lines = 10000,
  max_results = 8,
  min_chars = 2,
  width = 80,
}

local state = {
  bufnr = nil,
  candidates = {},
  config = vim.deepcopy(defaults),
  incsearch = nil,
  query = nil,
  selected = nil,
  winid = nil,
}

local regex_chars = {
  ["\\"] = true,
  ["["] = true,
  ["]"] = true,
  ["("] = true,
  [")"] = true,
  ["|"] = true,
  ["*"] = true,
  ["^"] = true,
  ["$"] = true,
}

local function termcodes(keys)
  return vim.api.nvim_replace_termcodes(keys, true, false, true)
end

local function valid_win(winid)
  return winid ~= nil and vim.api.nvim_win_is_valid(winid)
end

local function valid_buf(bufnr)
  return bufnr ~= nil and vim.api.nvim_buf_is_valid(bufnr)
end

local function save_incsearch()
  if state.incsearch == nil then
    state.incsearch = vim.o.incsearch
  end
end

local function restore_incsearch()
  if state.incsearch ~= nil then
    vim.o.incsearch = state.incsearch
    state.incsearch = nil
  end
end

local function current_search_cmdline()
  local cmdtype = vim.fn.getcmdtype()

  if cmdtype == "/" or cmdtype == "?" then
    return cmdtype
  end

  return nil
end

local function is_regex_query(query)
  for char in query:gmatch(".") do
    if regex_chars[char] then
      return true
    end
  end

  return false
end

local function byte_col(text, char_col)
  local byte = vim.fn.byteidx(text, char_col)

  if byte < 0 then
    return 1
  end

  return byte + 1
end

local function byte_index(text, char_col)
  local byte = vim.fn.byteidx(text, char_col)

  if byte < 0 then
    return #text
  end

  return byte
end

local function trim(value)
  return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function truncate(value, max_width)
  if vim.fn.strdisplaywidth(value) <= max_width then
    return value
  end

  return vim.fn.strcharpart(value, 0, math.max(max_width - 3, 0)) .. "..."
end

local function literal_search(value)
  return [[\V]] .. value:gsub("\\", "\\\\")
end

local function word_at_col(text, col)
  local start_col = math.max(col or 1, 1)

  if start_col > #text then
    start_col = #text
  end

  local first = start_col
  while first > 1 and text:sub(first - 1, first - 1):match("[%w_]") do
    first = first - 1
  end

  local last = start_col
  while last <= #text and text:sub(last, last):match("[%w_]") do
    last = last + 1
  end

  return text:sub(first, last - 1)
end

function M.setup_highlights()
  vim.api.nvim_set_hl(0, match_hl_group, {
    bold = true,
    fg = "#ffffff",
  })
end

function M.collect_candidates(bufnr, query, opts)
  opts = vim.tbl_extend("force", defaults, opts or {})
  query = query or ""

  if vim.fn.strcharlen(query) < opts.min_chars or is_regex_query(query) then
    return {}
  end

  if not valid_buf(bufnr) then
    return {}
  end

  local line_count = vim.api.nvim_buf_line_count(bufnr)
  if line_count > opts.max_buffer_lines then
    return {}
  end

  local items = {}
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for index, line in ipairs(lines) do
    if line:match("%S") then
      table.insert(items, {
        bufnr = bufnr,
        lnum = index,
        text = line,
      })
    end
  end

  local fuzzy = vim.fn.matchfuzzypos(items, query, {
    key = "text",
    limit = opts.max_results,
  })
  local matches = fuzzy[1] or {}
  local positions = fuzzy[2] or {}
  local scores = fuzzy[3] or {}
  local candidates = {}

  for index, item in ipairs(matches) do
    local candidate_positions = positions[index] or {}

    table.insert(candidates, {
      bufnr = item.bufnr,
      col = byte_col(item.text, candidate_positions[1] or 0),
      lnum = item.lnum,
      positions = candidate_positions,
      score = scores[index] or 0,
      text = item.text,
    })
  end

  return candidates
end

function M.search_pattern_for_candidate(candidate)
  local text = candidate and candidate.text or ""
  local word = word_at_col(text, candidate and candidate.col or 1)

  if word == "" then
    word = trim(text)
  end

  return literal_search(word)
end

local function match_bounds(positions)
  local first = nil
  local last = nil

  for _, position in ipairs(positions or {}) do
    if first == nil or position < first then
      first = position
    end

    if last == nil or position > last then
      last = position
    end
  end

  return first, last
end

local function candidate_preview(candidate, opts)
  local text = candidate.text or ""
  local first, last = match_bounds(candidate.positions)

  if first == nil or last == nil then
    return {
      highlights = {},
      text = truncate(trim(text), opts.width),
    }
  end

  local context = math.max(opts.context_chars or 0, 0)
  local char_count = vim.fn.strcharlen(text)
  local start_char = math.max(first - context, 0)
  local end_char = math.min(last + context + 1, char_count)
  local prefix = start_char > 0 and "..." or ""
  local suffix = end_char < char_count and "..." or ""
  local body = vim.fn.strcharpart(text, start_char, end_char - start_char)
  local preview = prefix .. body .. suffix
  local prefix_chars = vim.fn.strcharlen(prefix)
  local highlights = {}

  for _, position in ipairs(candidate.positions or {}) do
    if position >= start_char and position < end_char then
      local col = position - start_char + prefix_chars

      table.insert(highlights, {
        start_col = byte_index(preview, col),
        end_col = byte_index(preview, col + 1),
      })
    end
  end

  local leading = preview:match("^%s*") or ""
  if leading ~= "" then
    local leading_bytes = #leading
    preview = preview:sub(leading_bytes + 1)

    for index = #highlights, 1, -1 do
      local highlight = highlights[index]

      if highlight.end_col <= leading_bytes then
        table.remove(highlights, index)
      else
        highlight.start_col = math.max(highlight.start_col - leading_bytes, 0)
        highlight.end_col = highlight.end_col - leading_bytes
      end
    end
  end

  return {
    highlights = highlights,
    text = preview,
  }
end

local function refresh_candidates()
  local query = vim.fn.getcmdline()

  if state.query ~= query then
    state.selected = nil
  end

  state.query = query
  state.candidates = M.collect_candidates(
    vim.api.nvim_get_current_buf(),
    query,
    state.config
  )
end

local function render()
  local candidates = state.candidates

  if #candidates == 0 then
    M.close()
    return
  end

  local width = math.min(state.config.width, math.max(vim.o.columns - 2, 20))
  local height = #candidates
  local lines = {}
  local previews = {}

  for index, candidate in ipairs(candidates) do
    previews[index] = candidate_preview(candidate, {
      context_chars = state.config.context_chars,
      width = width,
    })
    table.insert(lines, previews[index].text)
  end

  if not valid_buf(state.bufnr) then
    state.bufnr = vim.api.nvim_create_buf(false, true)
    vim.bo[state.bufnr].bufhidden = "wipe"
  end

  vim.bo[state.bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(state.bufnr, 0, -1, false, lines)
  vim.api.nvim_buf_clear_namespace(state.bufnr, namespace, 0, -1)

  for index, preview in ipairs(previews) do
    if index == state.selected then
      vim.api.nvim_buf_set_extmark(
        state.bufnr,
        namespace,
        index - 1,
        0,
        {
          line_hl_group = "PmenuSel",
          priority = 100,
        }
      )
    end

    for _, highlight in ipairs(preview.highlights) do
      vim.api.nvim_buf_set_extmark(
        state.bufnr,
        namespace,
        index - 1,
        highlight.start_col,
        {
          end_col = highlight.end_col,
          hl_group = match_hl_group,
          priority = 200,
        }
      )
    end
  end

  vim.bo[state.bufnr].modifiable = false

  local row = math.max(0, vim.o.lines - vim.o.cmdheight - height - 1)
  local config = {
    border = "none",
    col = 0,
    focusable = false,
    height = height,
    relative = "editor",
    row = row,
    style = "minimal",
    width = width,
    zindex = 250,
  }

  if valid_win(state.winid) then
    vim.api.nvim_win_set_config(state.winid, config)
  else
    state.winid = vim.api.nvim_open_win(state.bufnr, false, config)
  end

  vim.wo[state.winid].winhl = "NormalFloat:Pmenu"
  pcall(vim.cmd, "redraw")
end

function M.close()
  if valid_win(state.winid) then
    vim.api.nvim_win_close(state.winid, true)
  end

  state.candidates = {}
  state.query = nil
  state.selected = nil
  state.winid = nil
end

function M.update()
  local cmdtype = current_search_cmdline()

  if not cmdtype then
    restore_incsearch()
    M.close()
    return
  end

  refresh_candidates()

  if #state.candidates > 0 then
    save_incsearch()
    vim.o.incsearch = false
  else
    restore_incsearch()
  end

  render()
end

function M.is_visible()
  return valid_win(state.winid) and #state.candidates > 0
end

function M.has_candidates()
  if not current_search_cmdline() then
    return false
  end

  if state.query == vim.fn.getcmdline() and #state.candidates > 0 then
    return true
  end

  return #M.collect_candidates(
    vim.api.nvim_get_current_buf(),
    vim.fn.getcmdline(),
    state.config
  ) > 0
end

local function ensure_candidates()
  if not current_search_cmdline() then
    return false
  end

  if
    state.query ~= vim.fn.getcmdline()
    or #state.candidates == 0
  then
    refresh_candidates()
  end

  if #state.candidates == 0 then
    return false
  end

  return true
end

local function select_next_index()
  if state.selected == nil then
    state.selected = 1
  else
    state.selected = state.selected % #state.candidates + 1
  end
end

local function select_prev_index()
  if state.selected == nil then
    state.selected = #state.candidates
  else
    state.selected = (state.selected - 2) % #state.candidates + 1
  end
end

function M.select_next()
  if not ensure_candidates() then
    return false
  end

  select_next_index()
  render()
  return true
end

function M.select_prev()
  if not ensure_candidates() then
    return false
  end

  select_prev_index()
  render()
  return true
end

function M.queue_select_next()
  if not ensure_candidates() then
    return false
  end

  select_next_index()
  vim.schedule(render)
  return true
end

function M.queue_select_prev()
  if not ensure_candidates() then
    return false
  end

  select_prev_index()
  vim.schedule(render)
  return true
end

function M.accept_selected()
  if state.selected == nil then
    return false
  end

  local candidate = state.candidates[state.selected]
  if candidate == nil then
    return false
  end

  local pattern = M.search_pattern_for_candidate(candidate)
  local winid = state.winid
  state.candidates = {}
  state.query = nil
  state.selected = nil
  state.winid = nil

  vim.schedule(function()
    if valid_win(winid) then
      vim.api.nvim_win_close(winid, true)
    end

    if vim.api.nvim_get_current_buf() ~= candidate.bufnr then
      return
    end

    vim.fn.setreg("/", pattern)
    pcall(function()
      vim.v.hlsearch = 1
    end)
    vim.o.hlsearch = vim.o.hlsearch

    vim.api.nvim_win_set_cursor(0, {
      candidate.lnum,
      math.max(candidate.col - 1, 0),
    })
    vim.cmd("normal! zv")
  end)

  return true
end

function M.setup(opts)
  state.config = vim.tbl_extend("force", defaults, opts or {})
  vim.on_key(nil, namespace)

  local group = vim.api.nvim_create_augroup("config.fzsearch", {
    clear = true,
  })

  M.setup_highlights()

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = M.setup_highlights,
    desc = "Refresh fuzzy slash search highlights",
  })

  vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineChanged" }, {
    group = group,
    pattern = "[/\\?]",
    callback = function()
      vim.defer_fn(M.update, 1)
    end,
    desc = "Update fuzzy slash search candidates",
  })

  vim.api.nvim_create_autocmd("CmdlineLeave", {
    group = group,
    pattern = "[/\\?]",
    callback = function()
      restore_incsearch()
      vim.schedule(M.close)
    end,
    desc = "Close fuzzy slash search candidates",
  })

  vim.on_key(function(key)
    if
      key ~= termcodes("<Tab>")
      and key ~= termcodes("<S-Tab>")
      and key ~= termcodes("<CR>")
      and current_search_cmdline()
    then
      M.update()
    end
  end, namespace)

  vim.keymap.set("c", "<Tab>", function()
    if M.queue_select_next() then
      return ""
    end

    return termcodes("<C-z>")
  end, {
    desc = "Select next fuzzy slash candidate",
    expr = true,
  })

  vim.keymap.set("c", "<S-Tab>", function()
    if M.queue_select_prev() then
      return ""
    end

    if vim.fn.wildmenumode() == 1 then
      return termcodes("<C-p>")
    end

    return termcodes("<C-z>")
  end, {
    desc = "Select previous fuzzy slash candidate",
    expr = true,
  })

  vim.keymap.set("c", "<CR>", function()
    if M.accept_selected() then
      return termcodes("<C-c>")
    end

    return termcodes("<CR>")
  end, {
    desc = "Accept fuzzy slash candidate",
    expr = true,
  })
end

return M
