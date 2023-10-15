local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

local env = vim.g.env
local capabilities = vim.g.helpers.lsp.make_capabilities(require("cmp_nvim_lsp"))
local make_on_attach_callback = vim.g.helpers.lsp.make_on_attach_callback(
  require("lsp-inlayhints"),
  require("telescope.builtin")
)

lspconfig["bashls"].setup {
  cmd = { env.lsp_paths.bashls, "start" },
  capabilities = capabilities,
  on_attach = make_on_attach_callback(),
  root_dir = util.find_git_ancestor,
}
