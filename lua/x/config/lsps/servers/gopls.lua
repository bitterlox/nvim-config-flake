local lspconfig = require("lspconfig")
local util = require("lspconfig.util")
local common = require("x.config.lsps.common")
local env = require("x.env")

lspconfig["gopls"].setup {
  capabilities = common.make_capabilities(),
  on_attach = common.make_on_attach_callback(),
  cmd = { env.lsp_paths.gopls, "serve" },
  filetypes = { "go", "gomod" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      -- general settings
      -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
      gofumpt = true,
      analyses = {
        -- analyzers settings
        -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
        fieldalignment = true,
        nilness = true,
        shadow = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
        unusedvariable = true,
      },
      -- use linters from staticcheck.io
      staticcheck = true,
      -- diagnostics reported by the gc_details command
      annotations = {
        bounds = true,
        escape = true,
        inline = true,
        ["nil"] = true,
      },
      hints = {
        -- inlayhints settings
        -- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  }
}
