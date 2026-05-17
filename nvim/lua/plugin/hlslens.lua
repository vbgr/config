vim.pack.add({
  {
    src = "https://github.com/kevinhwang91/nvim-hlslens",
    name = "nvim-hlslens",
    version = "be2d7b2",
  },
}, { load = true })

vim.api.nvim_set_keymap(
  "n",
  "n",
  [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "N",
  [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "*",
  [[*<Cmd>lua require('hlslens').start()<CR>]],
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "#",
  [[#<Cmd>lua require('hlslens').start()<CR>]],
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "g*",
  [[g*<Cmd>lua require('hlslens').start()<CR>]],
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "g#",
  [[g#<Cmd>lua require('hlslens').start()<CR>]],
  { noremap = true, silent = true }
)
