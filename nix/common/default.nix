{ pkgs }:
let lib = pkgs.lib;
in rec {
  dirs = {
    config = ../../lua/config;
    global = ../../lua/globals;
  };
  config = let
    getLuaFileNames = dir:
      (builtins.map lua.stripExtension (lua.findFilesInDir dir));
    # dir::String -> []::String
    # returns a list of paths
    buildConfigPaths = dir: builtins.attrValues (makeConfigFileSet dir);
    # config-dir::String -> { (filename)::String = (filepath)::String }
    makeConfigFileSet = config-dir:
      let
        mapFiltered = file: {
          name = file;
          value = "${config-dir}/${file}.lua";
        };
        listOfSets = builtins.map mapFiltered (getLuaFileNames config-dir);
      in builtins.listToAttrs listOfSets;
  in {
    editor-config = buildConfigPaths "${dirs.config}/editor-config";
    plugins = {
      extra-config = buildConfigPaths "${dirs.config}/plugins/extra-config";
      config = makeConfigFileSet "${dirs.config}/plugins/plugin-config";
      keybindings =
        makeConfigFileSet "${dirs.config}/plugins/plugin-keybindings";
    };
    globals = buildConfigPaths "${dirs.global}";
  };
  lua = {
    # fileName::String -> bool
    # return true is filename has `.lua` suffix
    isLuaFile = (filename: lib.strings.hasSuffix ".lua" filename);
    # fileName::String -> String
    # removes ".lua" from fileName 
    stripExtension = (filename: lib.strings.removeSuffix ".lua" filename);
    # dir::Path|String -> []::String
    # returns all lua files found at path `dir`
    findFilesInDir = dir:
      let filenames = (builtins.attrNames (builtins.readDir dir));
      in builtins.filter lua.isLuaFile filenames;
  };
}
