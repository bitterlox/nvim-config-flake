local lspconfig = require("lspconfig")
local common = require("x.config.lsps.common")
local env = require("x.env")


lspconfig["nixd"].setup {
  capabilities = common.make_capabilities(),
  on_attach = common.make_on_attach_callback(),
  cmd = { env.lsp_paths.nixd },
  -- defaults
  filetypes = { "nix" },
  -- root_dir  = util.root_pattern(".nixd.json", "flake.nix",".git"),
  -- single_file_support = true
}
