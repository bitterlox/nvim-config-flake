# i think this is cool, i'm "erecting abstraction barriers"
# using a flake-parts module i'm defining an interface to create new editors,
# an external consumer only need sto specify an new editor object with 
# plugins etc and a new editor is "bundled" and added to the flake outputs
# inside here i created the "Configuration" abstraction to
# bundle plugins and config in my editor
{ lib, ... }: {
  imports = [ ./options.nix ];
  perSystem = { inputs', config, system, pkgs, ... }:
    let
      # 1. plugins specify path to a lua file (or files) to include
      #   we can do away with all that code to match lua file names to plugin names
      #   if this work then split the lua top level folder into two sub-folders
      #   "autoloaded" "manual", remove "name" field from plugins
      # 2. make another nix file (in this dir) that normalizes the stuff we get from `config.neovim`
      #      should be pretty easy:
      #      - for plain lua config just grab all the lua files in the folder and call
      #        constructor on each (i can't understand when these files are put in the nix store);
      #        (they are put in the store when we pass "pathsToLua" to the module config)
      #      - for tools just call the newToolConfig constructor on the pkg
      #      - for plugins call the constructor and optionally merge with a config if present
      #    into a list of Configurations then we use the result of that to call package-custom-nvim
      customized-nvim = import ./custom-nvim.nix {
        inherit pkgs;
        inherit (builtins.elemAt config.neovim.editors 0) includeInPath plugins pathsToLua;
      };
    in {
      config = {
        packages.default = customized-nvim;
        apps.default = {
          type = "app";
          program = "${customized-nvim}/bin/nvim";
        };
      };
    };
  systems = [ "aarch64-darwin" "x86_64-linux" ];
}
