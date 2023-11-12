{
  description = "my neovim flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #    neovim = {
    #      url = "github:neovim/neovim/stable?dir=contrib";
    #      inputs.nixpkgs.follows = "nixpkgs";
    #    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    efmls-configs = {
      url = "github:creativenull/efmls-configs-nvim";
      flake = false;
    };
    sonokai = {
      url = "github:sainnhe/sonokai";
      flake = false;
    };
    adwaita = {
      url = "github:Mofiqul/adwaita.nvim";
      flake = false;
    };
    citruszest = {
      url = "github:zootedb0t/citruszest.nvim";
      flake = false;
    };
    caret = {
      url = "github:projekt0n/caret.nvim";
      flake = false;
    };
    melange = {
      url = "github:savq/melange-nvim";
      flake = false;
    };
  };
  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      perSystem = { inputs', system, pkgs, ... }:
        let
          overlayVimPlugins = prev: final:
            final.lib.recursiveUpdate final {
              vimPlugins = {
                customPlugins = {
                  efmls-configs =
                    import ./nix/custom-plugins/efmls-configs.nix {
                      pkgs = final;
                      src = inputs.efmls-configs;
                    };
                };
                customThemes = import ./nix/custom-plugins/themes.nix {
                  inherit pkgs;
                  srcs = {
                    inherit (inputs) sonokai adwaita citruszest caret melange;
                  };
                };
              };
              nodePackages = {
                bash-language-server =
                  import ./nix/custom-plugins/bash-language-server.nix {
                    pkgs = final;
                  };
              };
            };
          customized-nvim = import ./nix/custom-nvim.nix { inherit pkgs; };
        in {
          config = {
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [ overlayVimPlugins ];
            };
            packages.default = customized-nvim;
            apps.default = {
              type = "app";
              program = "${customized-nvim}/bin/nvim";
            };
          };
        };
      systems = [ "aarch64-darwin" "x86_64-linux" ];
    };
}
