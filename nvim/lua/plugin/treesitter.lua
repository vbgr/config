vim.pack.add({
  {
    src = "https://github.com/neovim-treesitter/treesitter-parser-registry",
    name = "treesitter-parser-registry",
  },
  {
    src = "https://github.com/neovim-treesitter/nvim-treesitter",
    name = "nvim-treesitter",
  },
}, { load = true })

local treesitter = require("nvim-treesitter")

treesitter.setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

local parsers = {
  "lua",
  "vim",
  "vimdoc",
  "markdown",
  "markdown_inline",
  "query",
  "json",
  "yaml",
  "go",
  "python",
  "typescript",
  "tsx",
  "javascript",
  "html",
  "css",
  "rust",
  "bash",
  "dockerfile",
  "terraform",
  "sql",
}

vim.treesitter.language.register("bash", "sh")
vim.treesitter.language.register("terraform", "tf")
vim.treesitter.language.register("tsx", "typescriptreact")

if treesitter.install and vim.fn.executable("tree-sitter") == 1 then
  treesitter.install(parsers)
end

local filetypes = {
  "lua",
  "vim",
  "help",
  "markdown",
  "json",
  "yaml",
  "go",
  "python",
  "typescript",
  "typescriptreact",
  "javascript",
  "html",
  "css",
  "rust",
  "sh",
  "bash",
  "dockerfile",
  "terraform",
  "tf",
  "sql",
}

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("NativeTreesitter", { clear = true }),
  pattern = filetypes,
  callback = function()
    local ok = pcall(vim.treesitter.start)

    if ok then
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end
  end,
})
