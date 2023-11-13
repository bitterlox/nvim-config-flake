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
    # themes i like: melange, adwaita, caret, sonokai is sort of like melange
    sonokai-theme = {
      url = "github:sainnhe/sonokai";
      flake = false;
    };
    adwaita-theme = {
      url = "github:Mofiqul/adwaita.nvim";
      flake = false;
    };
    citruszest-theme = {
      url = "github:zootedb0t/citruszest.nvim";
      flake = false;
    };
    caret-theme = {
      url = "github:projekt0n/caret.nvim";
      flake = false;
    };
    melange-theme = {
      url = "github:savq/melange-nvim";
      flake = false;
    };
  };
  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ./nix ];
      perSystem = { inputs', system, pkgs, ... }:
        let customized-nvim = import ./nix/custom-nvim.nix { inherit pkgs; };
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
    };
}
