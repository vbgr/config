vim.pack.add({
  {
    src = "https://github.com/nvim-tree/nvim-web-devicons",
    name = "nvim-web-devicons",
    version = "2795c26c916bb3c57dde308b82be51971fa92747",
  },
}, { load = true })

local devicons = require("nvim-web-devicons")

devicons.setup({
  override = {
    ["rst"] = { icon = "", color = "#519aba", name = "rst"},
    ["justfile"] = { icon = "", color = "#83c092", name = "Justfile" },
    ["sh"] = { icon = "", color = "#83c092", name = "shell" },
    ["zsh"] = { icon = "", color = "#83c092", name = "zsh" },
    ["tf"] = { icon = "", color = "#df69ba", name = "terraform" },
    ["tfvars"] = { icon = "", color = "#df69ba", name = "tfvars" },
    ["toml"] = { icon = "", color = "#83c092", name = "toml" },
  },
})

vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Refresh devicon highlights after colorscheme changes",
  callback = function()
    devicons.refresh()
  end,
})
