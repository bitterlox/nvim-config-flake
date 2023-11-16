{ pkgs, includeInPath, plugins, pathsToLua }:
let
  plugin-names =
    builtins.map (pluginSet: builtins.getAttr "name" pluginSet) plugins;
  plugin-packages =
    builtins.map (pluginSet: builtins.getAttr "package" pluginSet) plugins;

  validatedPathsToLua = builtins.mapAttrs (attr: val:
    pkgs.lib.throwIf (val == ./.) "option ${attr} is not defined" val)
    pathsToLua;

  getLuaFileNames = dir:
    let
      # fileName::String -> bool
      # return true is filename has `.lua` suffix
      isLuaFile = (filename: pkgs.lib.strings.hasSuffix ".lua" filename);
      # fileName::String -> String
      # removes ".lua" from fileName 
      stripExtension =
        (filename: pkgs.lib.strings.removeSuffix ".lua" filename);
      # dir::Path|String -> []::String
      # returns all lua files found at path `dir`
      findFilesInDir = dir:
        let filenames = (builtins.attrNames (builtins.readDir dir));
        in builtins.filter isLuaFile filenames;
    in (builtins.map stripExtension (findFilesInDir dir));

  buildConfigPaths = dir: builtins.attrValues (makeConfigFileSet dir);
  # config-dir::String -> { (filename)::String = (filepath)::String }
  makeConfigFileSet = dir:
    let
      mapFiltered = file: {
        name = file;
        value = "${dir}/${file}.lua";
      };
      listOfSets = builtins.map mapFiltered (getLuaFileNames dir);
    in builtins.listToAttrs listOfSets;

  # matches config files to plugins, maintaing the order of
  # plugins in the plugin list and spitting out warning for unused plugin files
  matchConfigFiles = configAttrSet: warnMsg:
    let
      matched = builtins.listToAttrs (builtins.filter (e: e != null)
        (builtins.map (file-name:
          let file-path = (builtins.getAttr file-name configAttrSet);
          in if (builtins.elem file-name plugin-names) then
            pkgs.lib.nameValuePair file-name file-path
          else
            pkgs.lib.trivial.warn "${warnMsg} (${file-name}.lua)" null)
          (builtins.attrNames configAttrSet)));
      attrNames = builtins.attrNames matched;
      sorted = builtins.sort (a: b:
        let
          eq = elem: (e: e == elem);
          aIdx = pkgs.lib.lists.findFirstIndex (eq a) null plugin-names;
          bIdx = pkgs.lib.lists.findFirstIndex (eq b) null plugin-names;
        in aIdx < bIdx) attrNames;
    in builtins.map (e: builtins.getAttr e matched) sorted;

  transformConfigPaths = {
    editorConfig = buildConfigPaths;
    globals = buildConfigPaths;
    pluginConfig = dirPath:
      matchConfigFiles (makeConfigFileSet dirPath)
      "unmatched plugin config won't be loaded";
    pluginKeyBindings = dirPath:
      matchConfigFiles (makeConfigFileSet dirPath)
      "unmatched plugin keybinding won't be loaded";
    pluginExtraConfig = buildConfigPaths;
  };

  configs = builtins.mapAttrs
    (attr: val: val (builtins.getAttr attr validatedPathsToLua))
    transformConfigPaths;

  lua-files = builtins.concatLists [
    configs.editorConfig
    configs.globals
    configs.pluginConfig
    configs.pluginKeyBindings
    configs.pluginExtraConfig
  ];
  # String | concatenated config files in the format vimrc expects
  rc = builtins.concatStringsSep "\n"
    (builtins.map (path: "luafile ${path}") lua-files);
  #rc = builtins.trace rctmp rctmp;
in pkgs.stdenv.mkDerivation { # add stuff to its paths
  name = "wrapped-nvim";
  src = with pkgs;
    wrapNeovim neovim-unwrapped {
      configure = {
        # here will come your custom configuration
        customRC = rc;
        packages = { all.start = plugin-packages; };
      };
    };
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  installPhase = ''
    makeWrapper $src/bin/nvim \
      $out/bin/nvim \
      --prefix PATH ":" ${pkgs.lib.makeBinPath includeInPath}
  '';
}
