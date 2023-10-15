{
  description = "my neovim flake";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
#    neovim = {
#      url = "github:neovim/neovim/stable?dir=contrib";
#      inputs.nixpkgs.follows = "nixpkgs";
#    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };
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
  outputs = { self, nixpkgs, flake-utils, efmls-configs, ... }@inputs: let
    systems = with flake-utils.lib.system; [ aarch64-darwin x86_64-linux ];


    in flake-utils.lib.eachSystem systems (system: 
      let
#        overlayNvim = prev: final: {
#          neovim-unwrapped = neovim.packages.${system}.neovim;
#        };

         overlayVimPlugins = prev: final: final.lib.recursiveUpdate
           final
           { vimPlugins = {
              customPlugins = {
               efmls-configs = import ./nix/custom-plugins/efmls-configs.nix {
                 pkgs = final;
                 src = efmls-configs;
               };
             };
             customThemes = import ./nix/custom-plugins/themes.nix {
                inherit pkgs;
                srcs = { inherit (inputs) sonokai adwaita citruszest caret melange; };
              };
             };
             nodePackages = {
               bash-language-server = import ./nix/custom-plugins/bash-language-server.nix {
                 pkgs = final;
               };
             };
           };

        pkgs = import nixpkgs { inherit system; overlays = [ overlayVimPlugins ]; };
        customized-nvim = import ./nix/custom-nvim.nix {
          inherit pkgs;
        };
      in
        { 
          packages.default = customized-nvim;
          apps.default = let
            in {
              type = "app";
              program = "${customized-nvim}/bin/nvim";
            };
        }
    );
}
