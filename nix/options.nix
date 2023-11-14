{ lib, ... }: {
  imports = [ ];
  config = {
    perSystem = { pkgs, ... }: {
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
      };
      options = {
        neovim = {
          includeInPath = lib.mkOption {
            type = with lib.types; listOf package;
            default = [ ];
            example = lib.literalMD "[ pkgs.rg ]";
            description = lib.mdDoc ''
              Packages added here will be included in the final nvim executable's PATH
            '';
          };
        };
      };
    };
  };
}
