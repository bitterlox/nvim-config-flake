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
  checkPkgOrPkgs = pkgOrPkgs:
    let
      doChecks = vals:
        lib.lists.foldl lib.trivial.and
        (builtins.map lib.attrsets.isDerivation vals) true;
      pkgs = lib.lists.flatten [ pkgOrPkgs ];
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
in {
  makeToolAddon = { pkgOrPkgs, cfgOrCfgs ? [ ] }:
    let
      pkgs = checkPkgOrPkgs pkgOrPkgs;
      cfgs = checkCfgs cfgOrCfgs;
    in {
      kind = "tool";
      package = pkgs;
      luaConfig = cfgs;
    };
  makePluginAddon = { pkgOrPkgs, cfgOrCfgs ? [ ] }:
    let
      pkgs = checkPkgOrPkgs pkgOrPkgs;
      cfgs = checkCfgs cfgOrCfgs;
    in {
      kind = "plugin";
      package = pkgs;
      luaConfig = cfgs;
    };
  makeLuaCfgAddon = { cfgOrCfgs }:
    let cfgs = checkCfgs cfgOrCfgs;
    in {
      kind = "config";
      package = null; # not sure if this fits in our system
      # this should fail if something that's not a list is passed
      luaConfig = cfgs;
    };
# TODO: make merge function, update constructors
  getTool = { kind, package, ... }: if kind == "tool" then package else null;
  getPlugin = { kind, package, ... }:
    if kind == "plugin" then package else null;
  getLuaCfg = { luaConfig, ... }: luaConfig;
}
