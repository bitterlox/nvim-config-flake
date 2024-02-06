# this is a flake-parts module
{ lib, ... }: {
  imports = [ ./packages ./configurations ];
  perSystem = { inputs', config, system, pkgs, ... }: {
    config = {
      #packages.default = customized-nvim;
      apps = let
        attrs = builtins.listToAttrs (builtins.map (e:
          let
            nvim-pkg = import ./nvim/package-custom-nvim.nix {
              inherit pkgs;
              inherit (e) name addons;
            };
          in lib.attrsets.nameValuePair "nvim-${e.name}" {
            type = "app";
            program = "${nvim-pkg}/bin/nvim";
          }) config.neovim.editors);
      in attrs // { default = attrs.nvim-full; };
    };
  };
  systems = [ "aarch64-darwin" "x86_64-linux" ];
}
