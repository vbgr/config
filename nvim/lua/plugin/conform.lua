vim.pack.add({
  {
    src = "https://github.com/stevearc/conform.nvim",
    name = "conform.nvim",
  },
}, { load = true })

local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
    go = { "goimports", "gofumpt" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    ["javascript.jsx"] = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    ["typescript.tsx"] = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    markdown = { "prettier" },
    yaml = { "yamlfmt" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    rust = { "rustfmt", lsp_format = "fallback" },
    terraform = { "terraform_fmt" },
    ["terraform-vars"] = { "terraform_fmt" },
    tf = { "terraform_fmt" },
    sql = { "sqruff" },
  },
  default_format_opts = {
    lsp_format = "fallback",
    timeout_ms = 3000,
  },
  notify_on_error = true,
})

vim.api.nvim_create_user_command("F", function()
  conform.format({
    async = false,
    bufnr = 0,
    lsp_format = "fallback",
    timeout_ms = 3000,
  })
end, {
  desc = "Format current buffer",
})
