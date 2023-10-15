local lspconfig = require("lspconfig")
local common = require("x.config.lsps.common")
local env = require("x.env")

lspconfig["rust_analyzer"].setup {
  cmd = { env.lsp_paths.rust_analyzer },
  capabilities = common.make_capabilities(),
  on_attach = common.make_on_attach_callback(),
  settings = {
    ["rust_analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
    },
  }
}
