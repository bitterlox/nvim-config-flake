local telescope = require("x.plugins.telescope")
local treesitter = require("x.plugins.treesitter")
local themes = require("x.plugins.themes")
local tpope = require("x.plugins.tpope")
local lspconfig = require("x.plugins.lspconfig")
local nvimcmp = require("x.plugins.nvimcmp")
local neodev = require("x.plugins.neodev")
local luasnip = require("x.plugins.luasnip")
local visualstarsearch = require("x.plugins.visualstarsearch")
local inlayhints = require("x.plugins.inlay-hints")
local neotest = require("x.plugins.neotest")
local tmux = require("x.plugins.tmux")
local nvimcokeline = require("x.plugins.nvim-cokeline")
local efmls_configs = require("x.plugins.efmls-configs")

return {
  -- fuzzy finder
  telescope,
  -- ast
  treesitter,
  -- themes
  themes,
  -- various plugins by tpope
  tpope,
  -- lsp-config
  lspconfig,
  -- nvimcmp
  nvimcmp,
  -- neodev - completion sources from plugins & neovim apis
  neodev,
  -- luasnip
  luasnip,
  -- search for visually highlighted text
  visualstarsearch,
  -- inlayhints
  inlayhints,
  -- neotest
  neotest,
  -- tmux - integrate with tmux
  tmux,
  -- nvim-cokeline - buffer line
  nvimcokeline,
  -- efmls configs,
  efmls_configs,
}
