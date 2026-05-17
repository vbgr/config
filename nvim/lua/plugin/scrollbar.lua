vim.pack.add({
  {
    src = "https://github.com/petertriho/nvim-scrollbar.git",
    name = "nvim-scrollbar",
    version = "f8e87b9",
  },
}, { load = true })

require("scrollbar").setup({
  set_highlights = true,
  marks = {
    Cursor = {
      priority = 10,
      text = " ",
    },
    Search = {
      priority = 1,
    },
    Error = {
      priority = 2,
    },
    Warn = {
      priority = 3,
    },
    Info = {
      priority = 4,
    },
    Hint = {
      priority = 5,
    },
    Misc = {
      priority = 6,
    },
  },
  handlers = {
    diagnostic = true,
    search = false,
    cursor = true,
    handle = true,
  },
  excluded_buftypes = {
    "terminal",
    "TelescopePrompt",
    "TelescopeResults",
    "packer",
    "lspsaga",
  },
  excluded_filetypes = {
    "packer",
    "lspsaga",
    "cmp_menu",
    "prompt",
    "TelescopePrompt",
    "TelescopeResults",
    "noice",
    "neo-tree",
    "lazy",
    "mason",
  },
})

local colors = vim.g.colorscheme_get_palette()
local hl = vim.g.colorscheme_highlight

hl("ScrollbarError", colors.red, colors.bg0)
hl("ScrollbarErrorHandle", colors.red, colors.bg1)
hl("ScrollbarWarn", colors.yellow, colors.bg0)
hl("ScrollbarWarnHandle", colors.yellow, colors.bg1)
hl("ScrollbarInfo", colors.green, colors.bg0)
hl("ScrollbarInfoHandle", colors.green, colors.bg1)
hl("ScrollbarMisc", colors.purple, colors.bg0)
hl("ScrollbarMiscHandle", colors.purple, colors.bg1)
