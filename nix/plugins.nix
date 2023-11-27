pkgs:
let
  customThemes = builtins.attrValues (builtins.mapAttrs (k: v: {
    name = k;
    package = v;
  }) pkgs.vimPlugins.customThemes);
in [
  {
    name = "nvim-lspconfig";
    package = pkgs.vimPlugins.nvim-lspconfig;
  }
  {
    name = "plenary-nvim";
    package = pkgs.vimPlugins.plenary-nvim;
  }

  # inlay hints
  {
    name = "lsp-inlayhints-nvim";
    package = pkgs.vimPlugins.lsp-inlayhints-nvim;
  }

  # neovim for lsp
  {
    name = "neodev-nvim";
    package = pkgs.vimPlugins.neodev-nvim;
  }

  # test runner
  {
    name = "neotest";
    package = pkgs.vimPlugins.neotest;
  }
  {
    name = "neotest-go";
    package = pkgs.vimPlugins.neotest-go;
  }
  {
    name = "neotest-jest";
    package = pkgs.vimPlugins.neotest-jest;
  }

  # status line
  {
    name = "nvim-cokeline";
    package = pkgs.vimPlugins.nvim-cokeline;
  }
  {
    name = "nvim-web-devicons";
    package = pkgs.vimPlugins.nvim-web-devicons;
  }

  # nvim-cmp
  {
    name = "cmp-buffer";
    package = pkgs.vimPlugins.cmp-buffer;
  }
  {
    name = "cmp-path";
    package = pkgs.vimPlugins.cmp-path;
  }
  {
    name = "cmp-cmdline";
    package = pkgs.vimPlugins.cmp-cmdline;
  }
  {
    name = "nvim-cmp";
    package = pkgs.vimPlugins.nvim-cmp;
  }
  # completion sources
  {
    name = "cmp-nvim-lsp";
    package = pkgs.vimPlugins.cmp-nvim-lsp;
  }
  #cmp-nvim-lua
  {
    name = "cmp_luasnip";
    package = pkgs.vimPlugins.cmp_luasnip;
  }
  #cmp-pluginNames
  # snippets
  {
    name = "luasnip";
    package = pkgs.vimPlugins.luasnip;
  }
  {
    name = "friendly-snippets";
    package = pkgs.vimPlugins.friendly-snippets;
  }

  # telescope
  {
    name = "telescope-nvim";
    package = pkgs.vimPlugins.telescope-nvim;
  }

  # themes
  {
    name = "rose-pine";
    package = pkgs.vimPlugins.rose-pine;
  }
  #minimal.nvim
  #sonokai
  #nightfox.nvim
  #adwaita.nvim
  #caret.nvim

  # tmux integration
  {
    name = "tmux-nvim";
    package = pkgs.vimPlugins.tmux-nvim;
  }

  # tpope vimPlugins
  # git client
  {
    name = "vim-fugitive";
    package = pkgs.vimPlugins.vim-fugitive;
  }
  # all about {name = "surroundings"; package = pkgs.vimPlugins.surroundings;}
  {
    name = "vim-surround";
    package = pkgs.vimPlugins.vim-surround;
  }
  # repeat commands
  {
    name = "vim-repeat";
    package = pkgs.vimPlugins.vim-repeat;
  }
  # improved netrw
  {
    name = "vim-vinegar";
    package = pkgs.vimPlugins.vim-vinegar;
  }
  # comment stuff
  {
    name = "vim-commentary";
    package = pkgs.vimPlugins.vim-commentary;
  }
  # treesitter + undotree
  {
    name = "nvim-treesitter";
    package = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
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
      p.scheme
    ]);
  }
  #"nvim-treesitter/playground"
  {
    name = "undotree";
    package = pkgs.vimPlugins.undotree;
  }

  # visual star search
  {
    name = "vim-visual-star-search";
    package = pkgs.vimPlugins.vim-visual-star-search;
  }

  ### - custom plugins - ###
  {
    name = "efmls-configs";
    package = pkgs.vimPlugins.customPlugins.efmls-configs;
  }
] ++ customThemes
