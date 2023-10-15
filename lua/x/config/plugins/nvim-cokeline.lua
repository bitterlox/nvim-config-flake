local cokeline = require("cokeline")
local register_keys = require("x.config.plugins.keybindings.nvim-cokeline")

register_keys()

local get_hex = require("cokeline/utils").get_hex

cokeline.setup({
  default_hl = {
    fg = function(buffer)
      return buffer.is_focused and get_hex("Normal", "fg") or get_hex("Comment", "fg")
    end,
    bg = get_hex("ColorColumn", "bg"),
  },

  components = {
    {
      text = "｜",
      fg = function(buffer)
        return buffer.is_modified and yellow or green
      end,
    },
    {
      text = function(buffer)
        return buffer.devicon.icon .. " "
      end,
      fg = function(buffer)
        return buffer.devicon.color
      end,
    },
    {
      text = function(buffer)
        return buffer.index .. ": "
      end,
    },
    {
      text = function(buffer)
        return buffer.unique_prefix
      end,
      fg = get_hex("Comment", "fg"),
      style = "italic",
    },
    {
      text = function(buffer)
        return buffer.filename .. " "
      end,
      style = function(buffer)
        return buffer.is_focused and "bold" or nil
      end,
    },
    {
      text = " ",
    },
  },
})
