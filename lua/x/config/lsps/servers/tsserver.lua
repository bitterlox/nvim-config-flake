local lspconfig = require("lspconfig")
local common = require("x.config.lsps.common")
local env = require("x.env")

lspconfig["tsserver"].setup {
  cmd = { env.lsp_paths.tsserver, "--stdio" },
  capabilities = common.make_capabilities(),
  on_attach = common.make_on_attach_callback(),
}
