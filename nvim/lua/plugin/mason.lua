vim.pack.add({
  {
    src = "https://github.com/mason-org/mason.nvim",
    name = "mason.nvim",
    version = "v2.2.1",
  },
}, { load = true })

local packages = {
  -- Core editor tooling
  "tree-sitter-cli",

  -- Python
  "ty",
  "ruff",

  -- JavaScript / TypeScript
  "typescript-language-server",
  "eslint-lsp",
  "prettier",

  -- Go
  "gopls",
  "goimports",
  "gofumpt",

  -- C / C++
  "clangd",
  "clang-format",

  -- Lua
  "lua-language-server",
  "stylua",

  -- Rust
  "rust-analyzer",

  -- Shell
  "shfmt",

  -- CSS / HTML
  "css-lsp",
  "html-lsp",

  -- Docker / Compose
  "dockerfile-language-server",
  "docker-compose-language-service",

  -- Terraform
  "terraform",
  "terraform-ls",

  -- JSON / YAML
  "json-lsp",
  "yaml-language-server",
  "yamlfmt",
  "yamllint",

  -- SQL
  "sqruff",

  -- Just
  "just-lsp",
}

require("mason").setup({
  PATH = "prepend",
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

vim.api.nvim_create_user_command("MasonInstallAll", function()
  vim.cmd("MasonInstall " .. table.concat(packages, " "))
end, {
  desc = "Install required Mason packages",
})

vim.api.nvim_create_user_command("MasonCheckExternal", function()
  if vim.fn.executable("rg") == 0 then
    vim.notify(
      "Missing rg. Install ripgrep via MacPorts: sudo port install ripgrep",
      vim.log.levels.WARN
    )
  end

  if vim.fn.executable("go") == 0 then
    vim.notify("Missing go. Mason Go tools need Go available on PATH.", vim.log.levels.WARN)
  end
end, {
  desc = "Check non-Mason external dependencies",
})
