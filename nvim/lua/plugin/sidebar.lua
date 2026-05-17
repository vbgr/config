vim.pack.add({
  {
--  src = "https://github.com/vbgr/nvim-sidebar.git",
    src = "~/src/me/nvim-sidebar",
    name = "nvim-sidebar",
--    version = "088d3eb28f186f8ad3cae777fe84a467a9aaf349",
  },
}, { load = true })

require("nvim-sidebar").setup({
  width = 40,
  side = "left",
  padding_left = 2,
  default_source = "files",
  sources = {
    "files",
    "buffers",
  },
  tree = {
    directory_type = "dir",
    exclude_patterns = {
      "^%.git$",
      "^%.DS_Store$",
      "%.pyc$",
      "^__pycache__$",
      "^node_modules$",
      "^%.venv$",
      "^%.pytest_cache$",
      "^%.ruff_cache$",
    },
  },
  trash_cmd = "trash",
})

vim.api.nvim_set_keymap(
  "n",
  "<leader>l",
  "<cmd>NvimSidebarLocate files<CR>",
  { noremap = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>b",
  "<cmd>NvimSidebar buffers<CR>",
  { noremap = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>d",
  "<cmd>NvimSidebarTree<CR>",
  { noremap = true }
)
