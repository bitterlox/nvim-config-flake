{ lib, ... }: {
  perSystem = { inputs', config, system, pkgs, ... }:
    let
      customized-nvim = import ../custom-nvim.nix {
        inherit pkgs;
        inherit (config.neovim) includeInPath;
        inherit (config.neovim) plugins;
      };
      # option definition expects plugins in this shape
      # { name::String, package::Derivation }
      plugins = import ./plugins.nix pkgs;
    in {
      config = {
        neovim.includeInPath = builtins.attrValues {
          # lsps
          inherit (pkgs)
            gopls lua-language-server rust-analyzer efm-langserver nil
            shellharden yamllint stylua nixfmt;
          inherit (pkgs.nodePackages)
            bash-language-server typescript-language-server jsonlint
            markdownlint-cli;
          # tools
          inherit (pkgs) ripgrep fd;
        };
        neovim.plugins = plugins;
        packages.default = customized-nvim;
        apps.default = {
          type = "app";
          program = lib.debug.traceSeqN 1 config.neovim.plugins
            "${customized-nvim}/bin/nvim";
        };
      };
    };
  systems = [ "aarch64-darwin" "x86_64-linux" ];
}
