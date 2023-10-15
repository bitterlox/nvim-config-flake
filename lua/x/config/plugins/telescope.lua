local telescope = require("telescope")
local register_keys = require("x.config.plugins.keybindings.telescope")

register_keys()

telescope.setup({
  pickers = {
    find_files = {
      theme = "dropdown",
    },
    git_files = {
      theme = "dropdown",
    },
    grep_string = {
      theme = "dropdown",
    },
    live_grep = {
      theme = "dropdown",
    },
    keymaps = {
      theme = "dropdown",
    },
    diagnostics = {
      theme = "dropdown",
    },
    lsp_references = {
      theme = "dropdown",
    },
    lsp_incoming_calls = {
      theme = "dropdown",
    },
    lsp_outgoing_calls = {
      theme = "dropdown",
    },
    lsp_definitions = {
      theme = "dropdown",
    },
    lsp_type_definitions = {
      theme = "dropdown",
    },
    lsp_implementations = {
      theme = "dropdown",
    },
  },
})
