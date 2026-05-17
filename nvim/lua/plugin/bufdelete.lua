vim.pack.add({
  {
    src = "https://github.com/vbgr/bufdelete.nvim",
    name = "bufdelete",
  },
})

vim.keymap.set("n", "<leader>w", "<cmd>Bdelete<CR>", {
  desc = "Delete buffer",
})
vim.keymap.set("n", "<leader>W", "<cmd>Bdelete!<CR>", {
  desc = "Force delete buffer",
})
