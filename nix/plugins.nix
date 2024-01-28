pkgs:
let
  customThemes = builtins.attrValues (builtins.mapAttrs (k: v: {
    kind = "plugin";
    package = v;
  }) pkgs.vimPlugins.customThemes);
in [
  {
    kind = "plugin";
    package = pkgs.vimPlugins.nvim-lspconfig;
  }
  {
    kind = "plugin";
    package = pkgs.vimPlugins.plenary-nvim;
  }

  # inlay hints
  {
    kind = "plugin";
    package = pkgs.vimPlugins.lsp-inlayhints-nvim;
    luaFiles = [ ../lua/config/plugins/plugin-config/lsp-inlayhints-nvim.lua ];
  }

  # neovim for lsp
  {
    kind = "plugin";
    package = pkgs.vimPlugins.neodev-nvim;
  }

  # test runner
  {
    kind = "plugin";
    package = pkgs.vimPlugins.neotest;
    luaFiles = [
      ../lua/config/plugins/plugin-config/neotest.lua
      ../lua/config/plugins/plugin-keybindings/neotest.lua
    ];
  }
  {
    kind = "plugin";
    package = pkgs.vimPlugins.neotest-go;
  }
  {
    kind = "plugin";
    package = pkgs.vimPlugins.neotest-jest;
  }

  # status line
  {
    kind = "plugin";
    package = pkgs.vimPlugins.nvim-cokeline;
    luaFiles = [
      ../lua/config/plugins/plugin-config/nvim-cokeline.lua
      ../lua/config/plugins/plugin-keybindings/nvim-cokeline.lua
    ];
  }
  {
    kind = "plugin";
    package = pkgs.vimPlugins.nvim-web-devicons;
  }

  # completion
  {
    kind = "plugin";
    package = pkgs.vimPlugins.cmp-buffer;
  }
  {
    kind = "plugin";
    package = pkgs.vimPlugins.cmp-path;
  }
  {
    kind = "plugin";
    package = pkgs.vimPlugins.cmp-cmdline;
  }
  # completion sources
  {
    kind = "plugin";
    package = pkgs.vimPlugins.cmp-nvim-lsp;
  }
  #cmp-nvim-lua
  {
    kind = "plugin";
    package = pkgs.vimPlugins.cmp_luasnip;
  }
  {
    kind = "plugin";
    package = pkgs.vimPlugins.nvim-cmp;
    luaFiles = [ ../lua/config/plugins/extra-config/autocompletion.lua ];
  }
  #cmp-pluginNames
  # snippets
  {
    kind = "plugin";
    package = pkgs.vimPlugins.luasnip;
  }
  {
    kind = "plugin";
    package = pkgs.vimPlugins.friendly-snippets;
  }

  # telescope
  {
    kind = "plugin";
    package = pkgs.vimPlugins.telescope-nvim;
    luaFiles = [
      ../lua/config/plugins/plugin-config/telescope-nvim.lua
      ../lua/config/plugins/plugin-keybindings/telescope-nvim.lua
    ];
  }

  # themes
  {
    kind = "plugin";
    package = pkgs.vimPlugins.rose-pine;
  }
  # tmux integration
  {
    kind = "plugin";
    package = pkgs.vimPlugins.tmux-nvim;
    luaFiles = [ ../lua/config/plugins/plugin-config/tmux-nvim.lua ];
  }

  # tpope vimPlugins
  # git client
  {
    kind = "plugin";
    package = pkgs.vimPlugins.vim-fugitive;
    luaFiles = [ ../lua/config/plugins/plugin-keybindings/vim-fugitive.lua ];
  }
  # all about { name = "surroundings"; package = pkgs.vimPlugins.surroundings;}
  {
    kind = "plugin";
    package = pkgs.vimPlugins.vim-surround;
  }
  # repeat commands
  {
    kind = "plugin";
    package = pkgs.vimPlugins.vim-repeat;
  }
  # improved netrw
  {
    kind = "plugin";
    package = pkgs.vimPlugins.vim-vinegar;
  }
  # comment stuff
  {
    kind = "plugin";
    package = pkgs.vimPlugins.vim-commentary;
  }
  # treesitter + undotree
  {
    kind = "plugin";
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
    luaFiles = [ ../lua/config/plugins/plugin-config/nvim-treesitter.lua ];
  }
  #"nvim-treesitter/playground"
  {
    kind = "plugin";
    package = pkgs.vimPlugins.undotree;
    luaFiles = [ ../lua/config/plugins/plugin-keybindings/undotree.lua ];
  }

  # visual star search
  {
    kind = "plugin";
    package = pkgs.vimPlugins.vim-visual-star-search;
  }

  ### - custom plugins - ###
  {
    kind = "plugin";
    package = pkgs.vimPlugins.customPlugins.efmls-configs;
  }
] ++ customThemes
