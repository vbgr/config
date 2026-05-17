vim.pack.add({
  {
    src = "https://github.com/lukas-reineke/indent-blankline.nvim.git",
    name = "indent-blankline",
    version = "v3.9.0",
  },
}, { load = true })

require("ibl").setup({
  indent = {
    char = "┊",
  },
  scope = {
    enabled = false,
  },
})
