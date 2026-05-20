local completion_group = vim.api.nvim_create_augroup("config.completion", {
  clear = true,
})

local protocol = vim.lsp.protocol

local kind_icons = {
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰊄",
}

local function pumvisible()
  return vim.fn.pumvisible() == 1
end

local function keycodes(keys)
  return keys
end

local function truncate(value, max_width)
  value = value or ""

  if vim.fn.strcharlen(value) <= max_width then
    return value
  end

  return vim.fn.strcharpart(value, 0, max_width - 3) .. "..."
end

local function lsp_completion_documentation(item)
  local documentation = item.documentation

  if type(documentation) == "string" then
    return documentation
  end

  if type(documentation) == "table" and type(documentation.value) == "string" then
    return documentation.value
  end

  return nil
end

local function lsp_completion_info(item)
  local documentation = lsp_completion_documentation(item)

  if not documentation or documentation == "" then
    return nil
  end

  local detail = item.detail

  if detail and detail ~= "" and not documentation:find(detail, 1, true) then
    return ("```%s\n%s\n```\n\n%s"):format(vim.bo.filetype, detail, documentation)
  end

  return documentation
end

local function format_lsp_completion_item(item)
  local kind = protocol.CompletionItemKind[item.kind] or "Unknown"
  local icon = kind_icons[kind] or "󰌋"
  local label = item.label or ""
  local label_detail = vim.tbl_get(item, "labelDetails", "detail") or ""
  local detail = item.detail
    or vim.tbl_get(item, "labelDetails", "description")
    or ""

  return {
    abbr = truncate(icon .. " " .. label .. label_detail, 60),
    info = lsp_completion_info(item),
    kind = kind,
    menu = truncate(detail ~= "" and "[LSP] " .. detail or "[LSP]", 40),
  }
end

local fd_cache = nil
local fd_cache_cwd = nil

local function fd_files()
  local cwd = vim.uv.cwd()

  if fd_cache and fd_cache_cwd == cwd then
    return fd_cache
  end

  fd_cache_cwd = cwd
  fd_cache = {}

  if vim.fn.executable("fd") ~= 1 then
    return fd_cache
  end

  local result = vim.system({
    "fd",
    "--type",
    "f",
    "--hidden",
    "--strip-cwd-prefix",
    "--exclude",
    ".git",
    "--exclude",
    ".venv",
    "--exclude",
    "node_modules",
    "--exclude",
    "dist",
    ".",
  }, {
    text = true,
  }):wait()

  if result.code ~= 0 then
    return fd_cache
  end

  fd_cache = vim.split(result.stdout or "", "\n", {
    plain = true,
    trimempty = true,
  })

  return fd_cache
end

local function fd_match(arglead)
  local files = fd_files()

  if arglead == "" then
    return files
  end

  return vim.fn.matchfuzzy(files, arglead)
end

function _G.ConfigFindFunc(cmdarg, cmdcomplete)
  if cmdcomplete then
    return fd_match(cmdarg)
  end

  if cmdarg ~= "" and vim.fn.filereadable(cmdarg) == 1 then
    return { cmdarg }
  end

  local matches = fd_match(cmdarg)

  if #matches == 0 then
    return {}
  end

  return { matches[1] }
end

local function enter()
  local ok, autopairs = pcall(require, "nvim-autopairs")

  if ok and autopairs.autopairs_cr then
    return vim.fn.keytrans(autopairs.autopairs_cr())
  end

  return keycodes("<CR>")
end

-- Insert-mode completion mappings.
vim.keymap.set("i", "<Tab>", function()
  return pumvisible() and keycodes("<C-n>") or keycodes("<Tab>")
end, {
  desc = "Select next completion item",
  expr = true,
  silent = true,
})

vim.keymap.set("i", "<S-Tab>", function()
  return pumvisible() and keycodes("<C-p>") or keycodes("<S-Tab>")
end, {
  desc = "Select previous completion item",
  expr = true,
  silent = true,
})

vim.keymap.set("i", "<CR>", function()
  if not pumvisible() then
    return enter()
  end

  if vim.fn.complete_info({ "selected" }).selected == -1 then
    return keycodes("<C-n><C-y>")
  end

  return keycodes("<C-y>")
end, {
  desc = "Accept completion item",
  expr = true,
  silent = true,
})

vim.keymap.set("i", "<C-Space>", function()
  vim.lsp.completion.get()
end, {
  desc = "Trigger LSP completion",
})

vim.api.nvim_create_autocmd("FileType", {
  group = completion_group,
  pattern = "TelescopePrompt",
  callback = function(event)
    vim.bo[event.buf].autocomplete = false
  end,
  desc = "Disable native autocomplete in Telescope prompts",
})

vim.api.nvim_create_autocmd("InsertCharPre", {
  group = completion_group,
  callback = function(event)
    local autocomplete = vim.api.nvim_get_option_value("autocomplete", { buf = event.buf })

    if autocomplete == nil then
      autocomplete = vim.o.autocomplete
    end

    if not autocomplete then
      return
    end

    if vim.fn.match(vim.v.char, [[\k]]) == 0 then
      vim.lsp.completion.get()
    end
  end,
  desc = "Trigger LSP completion for root-level words",
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = completion_group,
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, event.buf, {
        autotrigger = true,
        convert = format_lsp_completion_item,
      })
    end
  end,
})

vim.api.nvim_create_user_command("E", function(command)
  vim.cmd.edit(vim.fn.fnameescape(command.args))
end, {
  complete = function(arglead)
    return fd_match(arglead)
  end,
  desc = "Edit a file from fd",
  nargs = 1,
})

-- Command-line completion triggers.
vim.api.nvim_create_autocmd({ "CmdlineEnter", "DirChanged" }, {
  group = completion_group,
  pattern = "*",
  callback = function()
    fd_cache = nil
    fd_cache_cwd = nil
  end,
})

vim.api.nvim_create_autocmd("CmdlineChanged", {
  group = completion_group,
  pattern = ":",
  callback = function()
    vim.fn.wildtrigger()
  end,
})

vim.keymap.set("c", "<Up>", function()
  return vim.fn.wildmenumode() == 1 and keycodes("<C-e><Up>") or keycodes("<Up>")
end, {
  desc = "Previous command-line history item",
  expr = true,
})

vim.keymap.set("c", "<Down>", function()
  return vim.fn.wildmenumode() == 1 and keycodes("<C-e><Down>") or keycodes("<Down>")
end, {
  desc = "Next command-line history item",
  expr = true,
})
