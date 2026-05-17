vim.pack.add({
  {
    src = "https://github.com/sainnhe/everforest",
    name = "everforest",
    version = "c4bb2ae",
  },
}, { load = true })

vim.g.everforest_background = "soft"
vim.g.everforest_show_eob = 0
vim.g.everforest_better_performance = 1

local function get_palette()
  local background = vim.g.everforest_background
  local configuration = vim.fn["everforest#get_configuration"]()
  return vim.fn["everforest#get_palette"](background, configuration)
end

vim.g.colorscheme_get_palette = get_palette
vim.g.colorscheme_highlight = vim.fn["everforest#highlight"]

vim.cmd([[colorscheme everforest]])

vim.g.diagnostic_icons = {
  Error = " ",
  Warn = " ",
  Info = " ",
  Hint = "",
}

for name, icon in pairs(vim.g.diagnostic_icons) do
  vim.fn.sign_define(
    "DiagnosticSign" .. name,
    { text = icon, texthl = "DiagnosticSign" .. name }
  )
end

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = vim.g.diagnostic_icons.Error,
      [vim.diagnostic.severity.WARN] = vim.g.diagnostic_icons.Warn,
      [vim.diagnostic.severity.INFO] = vim.g.diagnostic_icons.Info,
      [vim.diagnostic.severity.HINT] = vim.g.diagnostic_icons.Hint,
    },
  },
})
