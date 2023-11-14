{ pkgs, includeInPath }:
let
  config-utils = (import ./common { inherit pkgs; }).config;

  plugins = import ./plugins.nix { inherit pkgs; };

  plugin-names = builtins.attrNames plugins;
  plugin-packages = builtins.attrValues plugins;

  plugin-config = config-utils.plugins.config;
  plugin-keybindings = config-utils.plugins.keybindings;

  matchConfigFiles = configAttrSet: warnMsg:
    builtins.filter (e: e != null) (builtins.map (file-name:
      let file-path = (builtins.getAttr file-name configAttrSet);
      in if (builtins.elem file-name plugin-names) then
        file-path
      else
        pkgs.lib.trivial.warn "${warnMsg} ${file-path}" null)
      (builtins.attrNames configAttrSet));

  matched-config = matchConfigFiles plugin-config "unused plugin config";
  matched-keybindings =
    matchConfigFiles plugin-keybindings "unused plugin keybinding";

  lua-files = let
    #plugin-specific = pkgs.lib.lists.flatten pluginConfigAndKeybindingPaths;
    extra-config = config-utils.plugins.extra-config;
  in builtins.concatLists [
    config-utils.editor-config
    config-utils.globals
    matched-config
    matched-keybindings
    extra-config
  ];
  # String | concatenated config files in the format vimrc expects
  rc = builtins.concatStringsSep "\n"
    (builtins.map (path: "luafile ${path}") lua-files);
  #rc = builtins.trace rctmp rctmp;
  wrapped = pkgs.wrapNeovim pkgs.neovim-unwrapped {
    configure = {
      # here will come your custom configuration
      customRC = rc;
      packages = { all.start = plugin-packages; };
    };
  };
  toolPaths = pkgs.lib.makeBinPath includeInPath;
in pkgs.stdenv.mkDerivation { # add stuff to its paths
  name = "wrapped-nvim";
  src = wrapped;
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  installPhase = ''
    makeWrapper $src/bin/nvim \
      $out/bin/nvim \
      --prefix PATH ":" ${toolPaths}
  '';
}
