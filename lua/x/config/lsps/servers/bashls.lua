local lspconfig = require("lspconfig")
local util = require("lspconfig.util")
local common = require("x.config.lsps.common")
local env = require("x.env")

lspconfig["bashls"].setup {
  cmd = { env.lsp_paths.bashls, "start" },
  capabilities = common.make_capabilities(),
  on_attach = common.make_on_attach_callback(),
  root_dir = util.find_git_ancestor,
}
