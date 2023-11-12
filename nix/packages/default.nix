# this is a flake-parts module
{ inputs, ... }: {
  perSystem = { inputs', system, pkgs, ... }:
    let
      overlayVimPlugins = prev: final:
        final.lib.recursiveUpdate final {
          vimPlugins.customPlugins = {
            efmls-configs = import ./efmls-configs.nix {
              pkgs = final;
              src = inputs.efmls-configs;
            };
          };
          vimPlugins.customThemes = import ./themes.nix {
            inherit pkgs;
            srcs = {
              inherit (inputs) sonokai adwaita citruszest caret melange;
            };
          };
          nodePackages.bash-language-server =
            import ./bash-language-server.nix { pkgs = final; };
        };
    in {
      config = {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ overlayVimPlugins ];
        };
      };
    };
  systems = [ "aarch64-darwin" "x86_64-linux" ];
}
