{ lib, ... }: {
  imports = [ ./options.nix ];
  perSystem = { inputs', config, system, pkgs, ... }:
    let
      customized-nvim = import ./custom-nvim.nix {
        inherit pkgs;
        inherit (config.neovim) includeInPath plugins pathsToLua;
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
