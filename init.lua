-- setup lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.runtimepath:prepend(lazypath)

local plugins = require("x.plugins")

local toinstall = {}

for i = #plugins, 1, -1 do
  local pkgs = plugins[i]
  local validatedpkgs = {}
  -- im here i can loop over pkg, and for entries that aren't a {}, turn them into {},
  -- so that we can also add a pin:true to easily pin/unpin all of the plugins
  for j = #pkgs, 1, -1 do
    local pkg = pkgs[j]
    if type(pkg) ~= "table" then
      validatedpkgs[j] = { pkg }
    else
      validatedpkgs[j] = pkg
    end
    -- can modify plugin tables en-masse
    -- pin package only if the table doesn't specify pinning,
    -- so avoid overriding
    if validatedpkgs[j].pin == nil then
      validatedpkgs[j].pin = true
    end
  end

  vim.list_extend(toinstall, validatedpkgs)
end

require("lazy").setup(toinstall, {})

-- add plugin to implement go interface
-- add format go on save
-- add special indenting rules per-language
-- add lsp incoming/outgoing calls
--
-- add testing through this package https://github.com/vim-test/vim-test
-- todo:
-- - sort out formating, linting, how those tie-in with LSP and lang-specific
--   plugins like go.nvim and rust-tools
-- - add basic tmux support
--
-- to remember keymappings i will simply create a telescope thing that
-- places me into the config/plugins/keybindings folder

-- √ 1. install which-key
-- √ 1.1 convert all keybinding to which-key
-- √ 1.2 re-think autocompletion keybindings
-- v 2. install null-ls and copy that guys's config, and see if it works
-- v 3. install nvim-lint and linters
-- 4. figure out why rust only works on the first buffer
-- 5. figure out go & rust support
-- remove null-ls, remove which-key
-- replace which-key with hydra panes
-- figure out go.nvim and rust-tools

-- - could use this to save some time https://github.com/folke/which-key.nvim
--   - could use hydra to make myself menus to remember bindings
--     - define keybindings in lua vars, then use the var to pass it to the actual
--       keybinding set fn and to the hydra menu, so when i change it there it auto
--       updates in other places
--     - then leader h pulls up a fuzzy finder that allows me to invoke any one of
--       these hydra menus to see shortcuts
-- - use null-ls to do formatting (both lsp and non-lsp)
-- - use nvim-lint to do linting that is no tied in LSPs
-- - go through go.nvim and rust-tools readme and figure out which features i like

-- maybe don't install ale, but get formatting capabilities from like, lsp-lua
-- - linters form here: https://github.com/mfussenegger/nvim-lint
-- - formatting from here: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
-- - try to only use go.nvim and rust-tools for unique features,
--   disable everything that can be achieved with more general
--   plugins (like formatting and diagnostic)
-- linters:
--  - js/ts: eslint
--  - go: lsp,
--  - rust: lsp,
--  - shells: shellcheck,
--  - vim: lsp + vint,
--  - html: ???,
--  - css: ???,
-- fixers:
--  - js/ts: prettier,
--  - go: gofumt, goimports,
--  - rust: rustfmt,
--  - shells: shellharden,
--  - vim
--  - html: ???,
--  - css: ???,
-- add proper go dev env, see that guy's nvim config i found
-- and this https://github.com/numToStr/Navigator.nvim

require("x.config")
