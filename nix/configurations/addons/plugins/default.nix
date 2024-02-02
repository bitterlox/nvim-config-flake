{ pkgs }:
let addon = import ../addon.nix;
in { 
 completion = import ./autocompletion { inherit pkgs; };
 essentials = import ./essentials { inherit pkgs; }; }
