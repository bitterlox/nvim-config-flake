local lspconfig = require("lspconfig")
local neodev = require("neodev")
local common = require("x.config.lsps.common")
local env = require("x.env")

-- this must be called before setting up lua lsp
neodev.setup({})

lspconfig["lua_ls"].setup {
  cmd = { env.lsp_paths.lua_ls },
  capabilities = common.make_capabilities(),
  on_attach = common.make_on_attach_callback(),
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      --        diagnostics = {
      --          -- Get the language server to recognize the `vim` global
      --          globals = { "vim" },
      --        },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  }
}
