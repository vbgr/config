vim.pack.add({
  {
    src = "https://github.com/nvim-telescope/telescope.nvim",
    name = "telescope",
    version = "7d32479",
  },
  {
    src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
    name = "telescope-fzf-native",
    version = "b25b749",
  },
  {
    src = "https://github.com/nvim-telescope/telescope-ui-select.nvim",
    name = "telescope-ui-select",
    version = "6e51d7d",
  },
}, { load = true })

local opts = {
  defaults = {
    preview = {
      filesize_limit = 0.5,
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--glob=!.venv/*",
      "--glob=!.git/*",
      "--glob=!node_modules/*",
    },
    prompt_prefix = "   ",
    layout_strategy = "vertical",
    layout_config = {
      height = 0.9,
      mirror = false,
      prompt_position = "bottom",
    },
    set_env = { COLORTERM = "truecolor" },
  },
  pickers = {
    find_files = {
      find_command = {
        "fd",
        "--type",
        "f",
        "--strip-cwd-prefix",
        "--hidden",
        "--exclude",
        ".git",
        "--exclude",
        ".venv",
        "--exclude",
        "__pycache__",
        "--exclude",
        "node_modules",
        "--exclude",
        "*.avro",
        "--exclude",
        "*.jsonl",
        "--exclude",
        "dist",
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "ignore_case",
    },
  },
}

local function make_previewer(job, previewers)
  return function(filepath, bufnr, preview_opts)
    filepath = vim.fn.expand(filepath)
    job:new({
      command = "file",
      args = { "--mime-type", "-b", filepath },
      on_exit = function(j)
        local result = j:result()
        local mime_type = vim.split(result[1] or "", "/")[1]

        if mime_type == "text" then
          previewers.buffer_previewer_maker(filepath, bufnr, preview_opts or {})
        else
          vim.schedule(function()
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
          end)
        end
      end,
    }):sync()
  end
end

local function setup_keymaps()
  local map = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, {
      desc = desc,
      noremap = true,
      silent = true,
    })
  end

  map("<leader>fa", vim.lsp.buf.code_action, "Code action")
  map("<leader>ff", "<cmd>Telescope find_files<CR>", "Find files")
  map("<leader>fb", "<cmd>Telescope buffers<CR>", "Find buffers")
  map("<leader>fh", "<cmd>Telescope help_tags<CR>", "Find help")
  map("fg", "<cmd>Telescope live_grep<CR>", "Live grep")
  map("T", "<cmd>Telescope grep_string only_sort_text=true<CR>", "Grep word")
  map("<leader>fd", "<cmd>Telescope lsp_definitions<CR>", "Find definitions")
  map("<leader>ft", "<cmd>Telescope lsp_type_definitions<CR>", "Find type definitions")
  map("<leader>fr", "<cmd>Telescope lsp_references<CR>", "Find references")
  map("<leader>fi", "<cmd>Telescope lsp_implementations<CR>", "Find implementations")
  map("<leader>fj", "<cmd>Telescope jumplist<CR>", "Find jumplist")
  map("<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", "Find document symbols")
  map("<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "Find workspace symbols")
  map("<leader>eb", "<cmd>Telescope diagnostics bufnr=0<CR>", "Find buffer diagnostics")
  map("<leader>ew", "<cmd>Telescope diagnostics<CR>", "Find workspace diagnostics")
  map("<leader>gc", "<cmd>Telescope git_commits<CR>", "Find git commits")
  map("<leader>gb", "<cmd>Telescope git_commits<CR>", "Find git commits")
  map("<leader>gB", "<cmd>Telescope git_branches<CR>", "Find git branches")
  map("<leader>gs", "<cmd>Telescope git_status<CR>", "Find git status")
  map("<leader>t", "<cmd>Telescope treesitter<CR>", "Find treesitter symbols")
end

local previewers = require("telescope.previewers")
local telescope = require("telescope")
local job = require("plenary.job")

opts = vim.tbl_deep_extend("force", opts, {
  defaults = {
    buffer_previewer_maker = make_previewer(job, previewers),
  },
  extensions = {
    ["ui-select"] = require("telescope.themes").get_dropdown({
      prompt_prefix = "   ",
      layout_strategy = "vertical",
      layout_config = {
        height = 0.4,
        mirror = false,
        prompt_position = "bottom",
      },
    }),
  },
})

telescope.setup(opts)
pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "ui-select")
setup_keymaps()
