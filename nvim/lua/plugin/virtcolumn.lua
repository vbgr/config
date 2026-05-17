vim.pack.add({
  {
    src = "https://github.com/lukas-reineke/virt-column.nvim.git",
    name = "virt-column",
    version = "v2.0.3",
  },
}, { load = true })

require("virt-column").setup({
  char = "┆",
})
