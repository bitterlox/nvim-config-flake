# A configuration has the form:
# {
#   addToPath: <derivation>
#   vimPlugin: <derivation>
#   luaConfig: <derivation>
# }
# ----
# the code will work as follows:
# - big function gets the big list as param
# - we want to ed up with sublists, filtering with the get* functions and filtering again the nils out
# - for each list we do the required processing and we kosher
{
  newToolConfig = pkg: {
    addToPath = pkg;
    vimPlugin = null;
    luaConfig = null;
  };
  newPluginConfig = pkg: {
    addToPath = null;
    vimPlugin = pkg;
    luaConfig = null;
  };
  newLuaConfig = pkg: {
    addToPath = null;
    vimPlugin = null;
    luaConfig = pkg;
  };
  mergeConfigs = cfg1@{ addToPath, vimPlugin, luaConfig }:
    cfg2@{ addToPath, vimPlugin, luaConfig }:
    cfg1 // cfg2;
  getTool = { addToPath, ... }: addToPath;
  getPlugin = { vimPlugin, ... }: vimPlugin;
  getLua = { luaConfig, ... }: luaConfig;
}
