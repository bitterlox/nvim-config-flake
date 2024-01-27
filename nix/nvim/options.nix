{ lib, ... }:
let
  types = lib.types;
  editor-option = types.submodule {
    options = {
      name = lib.mkOption {
        type = types.str;
        example = lib.literalMD "full";
        description = lib.mdDoc ''
          The string specified here will be appended to `neovim-` to name the package in flake outputs
        '';
      };
      includeInPath = lib.mkOption {
        type = types.listOf types.package;
        default = [ ];
        example = lib.literalMD "[ pkgs.rg ]";
        description = lib.mdDoc ''
          Packages added here will be included in the final nvim executable's PATH
        '';
      };
      plugins = lib.mkOption {
        type = types.listOf (types.submodule {
          options = {
            name = lib.mkOption {
              type = types.str;
              description = lib.mdDoc
                "This name will be used to match the appropriate config file to this plugin";
            };
            package = lib.mkOption { type = types.package; };
          };
        });
        default = [ ];
        example = lib.literalMD "[ pkgs.vimPlugins.fugitive ]";
        description = lib.mdDoc ''
          Packages added here will be loaded as neovim plugins
        '';
      };
      pathsToLua = let
        mkPathOption = desc:
          lib.mkOption {
            type = lib.types.path;
            default = ./.;
            description = lib.options.literalMD desc;
          };
      in {
        editorConfig = mkPathOption ''
          path to the directory containing general lua editor config
        '';
        globals = mkPathOption ''
          path to the directory containing lua code that interacts with vim.g
        '';
        pluginConfig = mkPathOption ''
          path to the directory containing lua config that will be matched
          to a corresponding plugin and loaded according to the order in which
          plugins are specified in plugins.nix
        '';
        pluginKeyBindings = mkPathOption ''
          path to the directory containing lua config (for keybindings) that
          will be matched to a corresponding plugin and loaded according to
          the order in which plugins are specified in plugins.nix
        '';
        pluginExtraConfig = mkPathOption ''
          path to the directory containing general non-matched lua config
          applied after all the plugin-specific config
        '';
      };
    };
  };
in {
  imports = [ ];
  config.perSystem = { ... }: {
    options.neovim.editors = lib.mkOption {
      type = types.nonEmptyListOf editor-option;
      #example = lib.literalMD "[{}]";
      description = lib.mdDoc ''
        The string specified here will be appended to `neovim-` to name the package in flake outputs
      '';
    };
  };
}
