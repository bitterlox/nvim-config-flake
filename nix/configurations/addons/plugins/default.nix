{ pkgs }:
let addon = import ../addon.nix;
in { essentials = import ./essentials { inherit pkgs; }; }
