function ClipboardYank()
  local content = vim.fn.getreg("")
  vim.fn.system("pbcopy", content)
end

function ClipboardPaste()
  local content = vim.fn.system("pbpaste")
  vim.fn.setreg("", content)
end

-- Abbreviations
vim.cmd([[cab Q qa]])
vim.cmd([[cab W w]])
vim.cmd([[cab Wq wq]])

-- Leader
vim.g.mapleader = ","

vim.api.nvim_set_keymap(
  "n",
  "<ESC>",
  ":noh<CR>",
  { noremap = true }
)

vim.api.nvim_set_keymap(
  "v",
  "q",
  "<ESC>",
  { noremap = true }
)

-- Trim trailing whitespaces
vim.api.nvim_set_keymap(
  "n",
  "<leader>x",
  ":%s/\\s\\+$//<CR>",
  { noremap = true }
)

-- Clipboard
vim.api.nvim_set_keymap(
  "v",
  "y",
  "y:lua ClipboardYank()<CR>",
  { silent = true }
)
vim.api.nvim_set_keymap(
  "v",
  "d",
  "d:lua ClipboardYank()<CR>",
  { silent = true }
)
vim.api.nvim_set_keymap(
  "v",
  "x",
  "x:lua ClipboardYank()<CR>",
  { silent = true }
)

-- Move selected lines left/right
vim.api.nvim_set_keymap(
  "v",
  "<",
  "<gv",
  { noremap = true, silent = false }
)
vim.api.nvim_set_keymap(
  "v",
  ">",
  ">gv",
  { noremap = true, silent = false }
)

-- Move selected lines up/down
vim.api.nvim_set_keymap(
  "x",
  "K",
  ":move -2<CR>gv-gv",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "x",
  "J",
  ":move +1<CR>gv-gv",
  { noremap = true, silent = true }
)

-- Window resize
vim.api.nvim_set_keymap(
  "n",
  "∆",
  ":resize -2<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "˚",
  ":resize +2<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "˙",
  ":vertical resize -2<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "¬",
  ":vertical resize +2<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<C-h>",
  "<C-w>h",
  { noremap = true, silent = false }
)
vim.api.nvim_set_keymap(
  "n",
  "<C-j>",
  "<C-w>j",
  { noremap = true, silent = false }
)
vim.api.nvim_set_keymap(
  "n",
  "<C-k>",
  "<C-w>k",
  { noremap = true, silent = false }
)
vim.api.nvim_set_keymap(
  "n",
  "<C-l>",
  "<C-w>l",
  { noremap = true, silent = false }
)

-- Buffers
vim.api.nvim_set_keymap(
  "n",
  "<leader>w",
  ":Bdelete<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>W",
  ":Bdelete!<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<Tab>",
  ":bn<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<S-Tab>",
  ":bp<CR>",
  { noremap = true, silent = true }
)
