{ lib, ... }: {
  perSystem = { inputs', config, system, pkgs, ... }:
    let
      customized-nvim = import ../custom-nvim.nix {
        inherit pkgs;
        inherit (config.neovim) includeInPath plugins pathsToLua;
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
        neovim.pathsToLua = {
          editorConfig = ../../lua/config/editor-config;
          globals = ../../lua/globals;
          pluginConfig = ../../lua/config/plugins/plugin-config;
          pluginKeyBindings = ../../lua/config/plugins/plugin-keybindings;
          pluginExtraConfig = ../../lua/config/plugins/extra-config;
        };
        packages.default = customized-nvim;
        apps.default = {
          type = "app";
          program = "${customized-nvim}/bin/nvim";
        };
      };
    };
  systems = [ "aarch64-darwin" "x86_64-linux" ];
}
