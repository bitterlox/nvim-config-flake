{ lib, ... }: {
  imports = [ ./options.nix ];
  perSystem = { pkgs, ... }:
    let
      tools = import ./addons/tools { inherit pkgs; };
      plugins = import ./addons/plugins { inherit pkgs; };
    in {
      config.neovim.editors = [{
        name = "full";
        addons = [ plugins.completion plugins.essentials ] ++ [
          # linters
          tools.yamllint
          tools.jsonlint
          tools.markdownlint-cli

          # formatters
          tools.shellharden
          tools.stylua
          tools.nixfmt

          # misc
          tools.ripgrep
          tools.fd
        ] ++ builtins.attrValues tools.lsps;
      }];
    };
  systems = [ "aarch64-darwin" "x86_64-linux" ];
}
