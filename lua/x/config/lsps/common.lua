local inlayhints = require("lsp-inlayhints")
local nvim_cmp_lsp = require("cmp_nvim_lsp")

local register_keybindings = require("x.config.lsps.keybindings")

local M = {}

function M.make_on_attach_callback()
  return function(client, bufnr)
    register_keybindings(client, bufnr)
    inlayhints.on_attach(client, bufnr, false)

    --vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    --vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    --vim.keymap.set('n', '<leader>wl', function()
    --  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    --end, bufopts)

    -- disable LSP formatting
    --vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, bufopts)
  end
end

function M.make_capabilities()
  return nvim_cmp_lsp.default_capabilities()
end

return M
