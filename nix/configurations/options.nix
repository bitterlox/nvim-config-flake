{ lib, ... }:
let
  types = lib.types;
  addon-type = types.submodule {
    options = {
      kind = types.enum [ "tool" "plugin" "config" ];
      package = types.listOf types.package;
      luaConfigs = types.listOf types.path;
    };
  };
  editor-type = types.submodule {
    options = {
      name = lib.mkOption {
        type = types.str;
        example = lib.literalMD "full";
        description = lib.mdDoc ''
          The string specified here will be appended to `neovim-` to name the package in flake outputs
        '';
      };
      addons = lib.mkOption {
        type = types.listOf addon-type;
        default = [ ];
        example = lib.literalMD "[ { ... } ]";
        description = lib.mdDoc ''
          These addons will be bundled with the editor
        '';
      };
    };
  };
in {
  imports = [ ];
  config.perSystem = { ... }: {
    options.neovim.editors = lib.mkOption {
      type = types.nonEmptyListOf editor-type;
      #example = lib.literalMD "[{}]";
      description = lib.mdDoc ''
        A list of editor addons.
      '';
    };
  };
}
