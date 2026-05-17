vim.pack.add({
  {
    src = "https://github.com/kylechui/nvim-surround.git",
    name = "nvim-surround",
    version = "v4.0.5",
  },
}, { load = true })

local config = require("nvim-surround.config")

require("nvim-surround").setup({
  surrounds = {
    ["f"] = {
      find = function()
        return config.get_selection({ node = "function_call" })
          or config.get_selection({
            pattern = "[^=%s%(%){}]+%b()",
          })
      end,
    },
  },
})
