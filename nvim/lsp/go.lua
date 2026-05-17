return {
  cmd = { "gopls" },
  filetypes = {
   "go",
   "gomod",
   "gowork",
   "gotmpl",
  },
  root_markers = { "go.mod", ".git" },
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
        },
      },
    },
  },
}
