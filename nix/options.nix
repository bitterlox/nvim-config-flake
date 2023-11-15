{ lib, ... }: {
  imports = [ ];
  config.perSystem = { pkgs, ... }: {
    options.neovim.includeInPath = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ ];
      example = lib.literalMD "[ pkgs.rg ]";
      description = lib.mdDoc ''
        Packages added here will be included in the final nvim executable's PATH
      '';
    };
    options.neovim.plugins = lib.mkOption {
      type = with lib.types;
        listOf (submodule {
          options = {
            name = lib.mkOption {
              type = str;
              description = lib.mdDoc
                "This name will be used to match the appropriate config file to this plugin";
            };
            package = lib.mkOption { type = package; };
          };
        });
      default = [ ];
      example = lib.literalMD "[ pkgs.vimPlugins.fugitive ]";
      description = lib.mdDoc ''
        Packages added here will be loaded as neovim plugins
      '';
    };
  };
}
