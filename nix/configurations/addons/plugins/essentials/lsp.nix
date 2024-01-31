{ pkgs }:
let addon = import ../addon.nix;
in addon.makePluginAddon {
  pkg = [
    pkgs.vimPlugins.neodev-nvim
    pkgs.vimPlugins.nvim-lspconfig
    pkgs.vimPlugins.lsp-inlayhints-nvim
  ];
  config = [ ../lua/config/plugins/plugin-config/lsp-inlayhints-nvim.lua ];
}
