{ pkgs }:
let
  addon = import ../addon.nix;
  lsp-essentials = import ./lsps.nix { inherit pkgs; };
  plenary = addon.makePluginAddon { pkg = pkgs.vimPlugins.plenary-nvim; };
in addon.mergeAddons lsp-essentials plenary

