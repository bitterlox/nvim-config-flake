{ pkgs, srcs }:
let
  buildThemePlugin = name: src:
    pkgs.vimUtils.buildVimPlugin { inherit name src; };
in builtins.mapAttrs (name: src: buildThemePlugin name src) srcs
