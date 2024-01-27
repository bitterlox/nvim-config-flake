# this is a flake-parts module
{ ... }: {
  imports = [ ./packages ./nvim ];
  perSystem = { pkgs, ... }: {
    config.neovim.editors = [{
      name = "full";
      includeInPath = builtins.attrValues {
        # lsps
        inherit (pkgs)
          gopls lua-language-server rust-analyzer efm-langserver nil shellharden
          yamllint stylua nixfmt;
        inherit (pkgs.nodePackages)
          bash-language-server typescript-language-server jsonlint
          markdownlint-cli;
        # tools
        inherit (pkgs) ripgrep fd;
      };
      # option definition expects plugins in this shape
      # { name::String, package::Derivation }
      plugins = import ./plugins.nix pkgs;
      pathsToLua = {
        editorConfig = ../lua/config/editor-config;
        globals = ../lua/globals;
        pluginConfig = ../lua/config/plugins/plugin-config;
        pluginKeyBindings = ../lua/config/plugins/plugin-keybindings;
        pluginExtraConfig = ../lua/config/plugins/extra-config;
      };
    }];
  };
}
