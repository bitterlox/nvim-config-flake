local lspconfig = require("lspconfig")
local common = require("x.config.lsps.common")
local env = require("x.env")

-- maybe pull code required for this into my own config
local prettier = require 'efmls-configs.formatters.prettier'
local eslint = require 'efmls-configs.linters.eslint'

local languages = {
  javascript = { eslint, prettier },
  typescript = { eslint, prettier },
  typescriptreact = { eslint, prettier },
  json = {
    {
      prefix = "jsonlint",
      lintCommand = env.efm_tools_paths.jsonlint .. " -c",
      lintStdin = true,
      lintFormats = { 'line %l, col %c, found: %m' },
    }
  },
  yaml = {
    {
      prefix = "yamllint",
      lintCommand = env.efm_tools_paths.yamllint .. " -s -f parsable ${INPUT}",
      lintStdin = true,
      -- this is vim error format https://vimhelp.org/quickfix.txt.html#error-file-format
      -- tested with https://github.com/reviewdog/errorformat (which is used in efm-langserver)
      lintFormats = { '%f:%l:%c: [%t%r] %m' },
    }
  },
  sh = {
    {
      formatCommand = env.efm_tools_paths.shellharden .. " --transform ${INPUT}",
      formatStdin = false,
    },
    require('efmls-configs.formatters.shfmt'),
  },
  markdown = {
    {
      prefix = "markdownlint",
      lintCommand = env.efm_tools_paths.markdownlint .. " parsable ${INPUT}",
      lintStdin = true,
      -- this is vim error format https://vimhelp.org/quickfix.txt.html#error-file-format
      -- tested with https://github.com/reviewdog/errorformat (which is used in efm-langserver)
      lintFormats = { '%f:%l %m' },
    }
  },
  lua = {
    {
      formatCommand = env.efm_tools_paths.stylua .. "-c --color never --output-format unified ${INPUT}",
      formatStdin = false,
    },
  },
}

lspconfig["efm"].setup {
  cmd = { env.lsp_paths.efm_langserver },
  capabilities = common.make_capabilities(),
  on_attach = common.make_on_attach_callback(),
  filetypes = vim.tbl_keys(languages),
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
  settings = {
    rootMarkers = { '.git/' },
    languages = languages,
  }
}
