{ pkgs }:
let
  addon = import ../addon.nix;
  customThemes = builtins.attrValues pkgs.vimPlugins.customThemes;
in addon.makePluginAddon {
  pkg = [ pkgs.vimPlugins.rose-pine ] ++ customThemes;
  config = [ ../lua/config/plugins/plugin-config/lsp-inlayhints-nvim.lua ];
}
