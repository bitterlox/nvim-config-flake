{ lib, ... }: {
  imports = [ ./options.nix ];
  perSystem = { pkgs, ... }:
    let
      # addon = lib.traceVal lib.lists (import ./addons/addon.nix { inherit lib; });
      addon = import ./addons/addon.nix {
        inherit pkgs;
      }; # if we pass flake-part's top-level arg lib this doesn't work wtf???
      tools = import ./addons/tools { inherit pkgs addon; };
      plugins = import ./addons/plugins { inherit pkgs addon; };
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
    in {
      config.neovim.editors = lib.debug.traceSeq (map (e: e.luaConfigs) addons)[{
        name = "full";
        addons =  addons;
      }];
    };
  systems = [ "aarch64-darwin" "x86_64-linux" ];
}
