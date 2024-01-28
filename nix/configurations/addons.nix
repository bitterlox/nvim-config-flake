let checkAddons = cfgs: builtins.map (x: x) cfgs;
in {
  makeToolAddon = { pkg, cfgs ? [] }: {
    kind = "tool";
    package = pkg;
    luaConfig = checkAddons cfgs;
  };
  makePluginAddon = { pkg, cfgs ? [] }: {
    kind = "plugin";
    package = pkg;
    luaConfig = checkAddons cfgs;
  };
  makeLuaCfgAddon = { cfgs }: {
    kind = "config";
    package = null;
    # this should fail if something that's not a list is passed
    luaConfig = checkAddons cfgs;
  };
  getTool = { kind, package, ... }:  if kind == "tool" then package else null;
  getPlugin = { kind, package, ... }: if kind == "plugin" then package else null;
  getLuaCfg = { luaConfig, ... }: luaConfig;
}
