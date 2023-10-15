# return a set from packagenames to packages;
# ( we need package names to load configfiles )
# this being a set means the order in which plugin configs are later loaded is
# not guaranteed
{ pkgs }:
{
  inherit (pkgs.vimPlugins) nvim-lspconfig;
  inherit (pkgs.vimPlugins) plenary-nvim;

  # efm langserver config
  #"creativenull/efmls-configs-nvim"

  # inlay hints
  inherit (pkgs.vimPlugins) lsp-inlayhints-nvim;

  # neovim for lsp
  inherit (pkgs.vimPlugins) neodev-nvim;

  # test runner
  inherit (pkgs.vimPlugins) neotest;
  inherit (pkgs.vimPlugins) neotest-go;
  inherit (pkgs.vimPlugins) neotest-jest;

  # status line
  inherit (pkgs.vimPlugins) nvim-cokeline;
  inherit (pkgs.vimPlugins) nvim-web-devicons;

  # nvim-cmp
  inherit (pkgs.vimPlugins) cmp-buffer;
  inherit (pkgs.vimPlugins) cmp-path;
  inherit (pkgs.vimPlugins) cmp-cmdline;
  inherit (pkgs.vimPlugins) nvim-cmp;
  # completion sources
  inherit (pkgs.vimPlugins) cmp-nvim-lsp;
  #cmp-nvim-lua
  inherit (pkgs.vimPlugins) cmp_luasnip;
  #cmp-pluginNames
  # snippets
  inherit (pkgs.vimPlugins) luasnip;
  inherit (pkgs.vimPlugins) friendly-snippets;

  # telescope
  inherit (pkgs.vimPlugins) telescope-nvim;

  # themes
  inherit (pkgs.vimPlugins) rose-pine;
  #minimal.nvim
  #sonokai
  #nightfox.nvim
  #adwaita.nvim
  #caret.nvim

  # tmux integration
  inherit (pkgs.vimPlugins) tmux-nvim;

  # tpope vimPlugins
  # git client
  inherit (pkgs.vimPlugins) vim-fugitive;
  # all about inherit (pkgs.vimPlugins) surroundings;
  inherit (pkgs.vimPlugins) vim-surround;
  # repeat commands
  inherit (pkgs.vimPlugins) vim-repeat;
  # improved netrw
  inherit (pkgs.vimPlugins) vim-vinegar;
  # comment stuff
  inherit (pkgs.vimPlugins) vim-commentary;

  # treesitter + undotree
  nvim-treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.vimdoc
    p.vim
    p.go
    p.c
    p.lua
    p.rust
    p.typescript
    p.javascript
    p.bash
    p.html
    p.css
    p.bash
  ]);
  #"nvim-treesitter/playground"
  inherit (pkgs.vimPlugins) undotree;

  # visual star search
  inherit (pkgs.vimPlugins) vim-visual-star-search;

  ### - custom plugins - ###

  inherit (pkgs.vimPlugins.customPlugins) efmls-configs;
} // pkgs.vimPlugins.customThemes
