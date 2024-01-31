# in the future i could extend this to be able to merge addons together
# simply make package be a list of packages, and we can enable merging
# by merging the lists of packages and the lists of configs (provided the kind
# is the same)
# this could enable cool things like, nvim-cmp requries like 20 diff plugins
# we can merge them all inside a single addons for ease of use, while still
# being open to defining two tools singularly (eg bash_ls and shellcheck)
# buy also providing a merged addons (which we'll most likely use all the time)
# would need to be able to type check the "pkgs" in the argset to make sure it contains
# at least one package, or just allow merging through the appropriate mergefn
# and not through the constructor
lib:
let
  # todo: pull out functionality under single fn
  checkPkgOrPkgs = pkg:
    let
      doChecks = vals:
        lib.lists.foldl lib.trivial.and
        (builtins.map lib.attrsets.isDerivation vals) true;
      pkgs = lib.lists.flatten [ pkg ];
    in if (doChecks pkgs) then
      pkgs
    else
      lib.trivial.throwIf true
      "pkg is not derivation nor a list of derivations";

  checkCfgs = pathOrPaths:
    let
      doChecks = vals:
        lib.lists.foldl lib.trivial.and
        (builtins.map lib.strings.isStorePath vals) true;
      paths = lib.lists.flatten [ pathOrPaths ];
    in if (doChecks paths) then
      paths
    else
      lib.trivial.throwIf true
      "cfgs is not store path nor a list of store paths";
in rec {
  makeToolAddon = { pkg, config ? [ ] }:
    let
      pkgs = checkPkgOrPkgs pkg;
      cfgs = checkCfgs config;
    in {
      kind = "tool";
      packages = pkgs;
      luaConfig = cfgs;
    };
  makePluginAddon = { pkg, config ? [ ] }:
    let
      pkgs = checkPkgOrPkgs pkg;
      cfgs = checkCfgs config;
    in {
      kind = "plugin";
      packages = pkgs;
      luaConfig = cfgs;
    };
  makeLuaCfgAddon = { config }:
    let cfgs = checkCfgs config;
    in {
      kind = "config";
      packages = null; # not sure if this fits in our system
      # this should fail if something that's not a list is passed
      luaConfig = cfgs;
    };
  # TODO: make merge function, update constructors
  mergeAddons = addon1: addon2:
    let
      kind1 = (getAddonKind addon1);
      kind2 = (getAddonKind addon2);
      selectorSet = {
        "tools" = getTools;
        "plugins" = getPlugins;
        "luaConfigs" = getLuaCfgs;
      };
      constructorsSet = {
        "tools" = cfgs: pkgs:
          makeToolAddon {
            pkg = pkgs;
            config = cfgs;
          };
        "plugins" = cfgs: pkgs:
          makePluginAddon {
            pkg = pkgs;
            config = cfgs;
          };
        "luaConfigs" = cfgs: pkgs: makeLuaCfgAddon { config = cfgs; };
      };
    in if (kind1 == kind2) then
      let
        pkgs = builtins.map selectorSet.${kind1} [ kind1 kind2 ];
        cfgs = builtins.map getLuaCfgs [ kind1 kind2 ];
      in constructorsSet.${kind1} cfgs pkgs
    else
      lib.trivial.throwIf true "can't merge addons not of the same kind" { };
  getAddonKind = { kind, ... }: kind;
  getTools = addon@{ packages, ... }:
    if (getAddonKind addon) == "tool" then packages else null;
  getPlugins = addon@{ packages, ... }:
    if (getAddonKind addon) == "plugin" then packages else null;
  getLuaCfgs = { luaConfig, ... }: luaConfig;
}
