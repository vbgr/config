local root_markers = {
  "pyproject.toml",
  "uv.lock",
  "requirements.txt",
  "setup.py",
  "setup.cfg",
  ".git",
}

local function path_join(...)
  return table.concat({ ... }, "/")
end

local function find_venv_root(start)
  local dir = vim.fs.normalize(start)

  while dir and dir ~= "" do
    local venv = path_join(dir, ".venv")
    local stat = vim.uv.fs_stat(venv)

    if stat and stat.type == "directory" then
      return dir
    end

    local parent = vim.fs.dirname(dir)

    if parent == dir then
      return nil
    end

    dir = parent
  end

  return nil
end

local function root_dir(bufnr, on_dir)
  local path = vim.api.nvim_buf_get_name(bufnr)
  local start = path ~= "" and vim.fs.dirname(path) or vim.uv.cwd()

  on_dir(find_venv_root(start) or vim.fs.root(start, root_markers) or start)
end

return {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_dir = root_dir,
  settings = {
    ty = {},
  },
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
