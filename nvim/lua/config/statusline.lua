local M = {}

local modes = {
  [""] = { "VISUAL", "StatusLineModeVisual" },
  c = { "COMMAND", "StatusLineModeCommand" },
  i = { "INSERT", "StatusLineModeInsert" },
  ic = { "INSERT", "StatusLineModeInsert" },
  n = { "NORMAL", "StatusLineModeNormal" },
  no = { "NORMAL", "StatusLineModeNormal" },
  r = { "PROMPT", "StatusLineModeReplace" },
  R = { "REPLACE", "StatusLineModeReplace" },
  Rv = { "V-REPLACE", "StatusLineModeReplace" },
  s = { "SELECT", "StatusLineModeVisual" },
  S = { "S-LINE", "StatusLineModeVisual" },
  t = { "TERMINAL", "StatusLineModeTerminal" },
  v = { "VISUAL", "StatusLineModeVisual" },
  V = { "V-LINE", "StatusLineModeVisual" },
}

local function palette()
  local ok, config = pcall(vim.fn["everforest#get_configuration"])

  if not ok then
    return nil
  end

  return vim.fn["everforest#get_palette"](
    config.background,
    config.colors_override
  )
end

local function set_hl(name, opts)
  vim.api.nvim_set_hl(0, name, opts)
end

function M.setup_highlights()
  local p = palette()

  if not p then
    return
  end

  set_hl("StatusLineModeNormal", {
    bg = p.statusline1[1],
    bold = true,
    fg = p.bg0[1],
  })
  set_hl("StatusLineModeInsert", {
    bg = p.statusline2[1],
    bold = true,
    fg = p.bg0[1],
  })
  set_hl("StatusLineModeVisual", {
    bg = p.statusline3[1],
    bold = true,
    fg = p.bg0[1],
  })
  set_hl("StatusLineModeReplace", {
    bg = p.orange[1],
    bold = true,
    fg = p.bg0[1],
  })
  set_hl("StatusLineModeCommand", {
    bg = p.aqua[1],
    bold = true,
    fg = p.bg0[1],
  })
  set_hl("StatusLineModeTerminal", {
    bg = p.purple[1],
    bold = true,
    fg = p.bg0[1],
  })
  set_hl("StatusLineSectionB", {
    bg = p.bg2[1],
    fg = p.grey2[1],
  })
  set_hl("StatusLineSectionC", {
    bg = p.bg2[1],
    fg = p.grey1[1],
  })
  set_hl("StatusLineDiagnosticError", {
    bg = p.bg2[1],
    fg = p.red[1],
  })
  set_hl("StatusLineDiagnosticWarn", {
    bg = p.bg2[1],
    fg = p.yellow[1],
  })
  set_hl("StatusLineDiagnosticInfo", {
    bg = p.bg2[1],
    fg = p.blue[1],
  })
  set_hl("StatusLineDiagnosticHint", {
    bg = p.bg2[1],
    fg = p.green[1],
  })
  set_hl("StatusLineLocation", {
    link = "TabLine",
  })
  set_hl("StatusLineProgress", {
    link = "TabLineSel",
  })
  set_hl("StatusLine", {
    bg = p.bg2[1],
    fg = p.grey1[1],
  })
end

local function escape(value)
  local escaped = tostring(value):gsub("%%", "%%%%")
  return escaped
end

local function compact(parts)
  local output = {}

  for _, part in ipairs(parts) do
    if part ~= nil and part ~= "" then
      table.insert(output, tostring(part))
    end
  end

  return table.concat(output, " ")
end

local function stl_hl(name)
  return "%#" .. name .. "#"
end

local function hl(name, value)
  return stl_hl(name) .. escape(value)
end

local function section(name, parts)
  local value = compact(parts)

  if value == "" then
    return ""
  end

  return hl(name, " " .. value .. " ")
end

local function raw_section(name, value)
  if value == nil or value == "" then
    return ""
  end

  return stl_hl(name) .. " " .. value .. " "
end

local function status_win()
  local winid = tonumber(vim.g.statusline_winid)

  if winid ~= nil and vim.api.nvim_win_is_valid(winid) then
    return winid
  end

  return vim.api.nvim_get_current_win()
end

local function status_buf(winid)
  return vim.api.nvim_win_get_buf(winid)
end

local function mode()
  local current = vim.api.nvim_get_mode().mode
  local mode_info = modes[current]

  if mode_info == nil then
    mode_info = { current:upper(), "StatusLineModeNormal" }
  end

  return hl(mode_info[2], " " .. mode_info[1] .. " ")
end

local function file_name(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)

  if name == "" then
    return "[No Name]"
  end

  return vim.fn.fnamemodify(name, ":.")
end

local function access(bufnr)
  if vim.bo[bufnr].readonly or not vim.bo[bufnr].modifiable then
    return "RO"
  end

  return "RW"
end

local function modified(bufnr)
  if vim.bo[bufnr].modified then
    return "+"
  end

  return "-"
end

local function diagnostic_count(bufnr, severity)
  local diagnostics = vim.diagnostic.get(bufnr, {
    severity = severity,
  })

  return #diagnostics
end

local function diagnostic_label(icon, count)
  return icon:gsub("%s+$", "") .. " " .. count
end

local function diagnostics(bufnr)
  local severity = vim.diagnostic.severity
  local icons = vim.g.diagnostic_icons or {}
  local parts = {
    {
      icons.Error or "E",
      diagnostic_count(bufnr, severity.ERROR),
      "StatusLineDiagnosticError",
    },
    {
      icons.Warn or "W",
      diagnostic_count(bufnr, severity.WARN),
      "StatusLineDiagnosticWarn",
    },
    {
      icons.Info or "I",
      diagnostic_count(bufnr, severity.INFO),
      "StatusLineDiagnosticInfo",
    },
    {
      icons.Hint or "H",
      diagnostic_count(bufnr, severity.HINT),
      "StatusLineDiagnosticHint",
    },
  }
  local output = {}

  for _, part in ipairs(parts) do
    if part[2] > 0 then
      table.insert(output, stl_hl(part[3]) .. escape(diagnostic_label(part[1], part[2])))
    end
  end

  if #output == 0 then
    return ""
  end

  return table.concat(output, stl_hl("StatusLineSectionC") .. " ")
    .. stl_hl("StatusLineSectionC")
end

local function encoding(bufnr)
  if vim.bo[bufnr].fileencoding ~= "" then
    return vim.bo[bufnr].fileencoding
  end

  return vim.o.encoding
end

local function file_icon(bufnr)
  local ok, devicons = pcall(require, "nvim-web-devicons")

  if not ok then
    return ""
  end

  local ft = vim.bo[bufnr].filetype
  local icon, icon_hl = devicons.get_icon_by_filetype(ft, {
    default = true,
  })

  if icon == nil or icon_hl == nil then
    return ""
  end

  return "%#" .. icon_hl .. "#" .. icon .. "%#StatusLineSectionC#"
end

local function file_type(bufnr)
  if vim.bo[bufnr].filetype == "" then
    return "no ft"
  end

  return vim.bo[bufnr].filetype
end

local function line_column(winid)
  local cursor = vim.api.nvim_win_get_cursor(winid)

  return cursor[1] .. ":" .. cursor[2] + 1
end

local function progress(winid)
  local bufnr = vim.api.nvim_win_get_buf(winid)
  local cursor = vim.api.nvim_win_get_cursor(winid)
  local current = cursor[1]
  local total = vim.api.nvim_buf_line_count(bufnr)

  if current < 1 then
    return "0%"
  end

  if total <= 1 then
    return "100%"
  end

  return math.floor((current - 1) / (total - 1) * 100) .. "%"
end

local function inactive(bufnr)
  return hl("StatusLineNC", " " .. file_name(bufnr) .. " ")
    .. "%#StatusLineNC#%="
end

function M.render()
  local winid = status_win()
  local bufnr = status_buf(winid)

  if winid ~= vim.api.nvim_get_current_win() then
    return inactive(bufnr)
  end

  local file = section("StatusLineLocation", {
    file_name(bufnr),
    access(bufnr),
    modified(bufnr),
  })
  local diag = raw_section("StatusLineSectionC", diagnostics(bufnr))
  local right = raw_section("StatusLineSectionC", compact({
    encoding(bufnr),
    vim.bo[bufnr].fileformat,
    file_icon(bufnr),
    file_type(bufnr),
  }))
  local location = section("StatusLineLocation", {
    line_column(winid),
  })
  local percent = section("StatusLineProgress", {
    progress(winid),
  })

  return mode()
    .. file
    .. diag
    .. "%#StatusLineSectionC#%="
    .. right
    .. location
    .. percent
end

M.setup_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Refresh statusline highlights",
  callback = M.setup_highlights,
})

vim.o.statusline = "%!v:lua.require('config.statusline').render()"

return M
