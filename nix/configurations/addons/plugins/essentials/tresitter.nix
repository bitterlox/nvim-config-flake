{ pkgs }:
let addon = import ../addon.nix;
in addon.makePluginAddon {
  pkg = [
    pkgs.vimPlugins.nvim-treesitter.withPlugins
    (p: [
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
    ])
    pkgs.vimPlugins.undotree
  ];
  config = [
    ../lua/config/plugins/plugin-config/nvim-treesitter.lua
    ../lua/config/plugins/plugin-keybindings/undotree.lua
  ];
}