vim.pack.add({
  {
    src = "https://github.com/windwp/nvim-autopairs.git",
    name = "nvim-autopairs",
    version = "7b9923a",
  },
}, { load = true })

local npairs = require("nvim-autopairs")
local rule = require("nvim-autopairs.rule")

npairs.setup({
  check_ts = true,
  enable_check_bracket_line = true,
  fast_wrap = {
    map = "<C-a>",
  },
  map_cr = false,
})

npairs.add_rules({
  rule(" ", " "):with_pair(function(opts)
    local pair = opts.line:sub(opts.col - 1, opts.col)
    return vim.tbl_contains({ "()", "[]", "{}" }, pair)
  end),
  rule("( ", " )")
    :with_pair(function()
      return false
    end)
    :with_move(function(opts)
      return opts.prev_char:match(".%)") ~= nil
    end)
    :use_key(")"),
  rule("{ ", " }")
    :with_pair(function()
      return false
    end)
    :with_move(function(opts)
      return opts.prev_char:match(".%}") ~= nil
    end)
    :use_key("}"),
  rule("[ ", " ]")
    :with_pair(function()
      return false
    end)
    :with_move(function(opts)
      return opts.prev_char:match(".%]") ~= nil
    end)
    :use_key("]"),
})
