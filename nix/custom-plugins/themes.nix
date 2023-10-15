# rose-pine
# sonokai
# adwaita
# carbonfox - meh. sort of like adawaita but i like the other's colors better
# caret - idk its green but i don't mind
{ pkgs, srcs }: let
  buildThemePlugin = name: src: pkgs.vimUtils.buildVimPlugin {
    inherit name src;
  }; in builtins.mapAttrs (name: src: buildThemePlugin name src)
  srcs
