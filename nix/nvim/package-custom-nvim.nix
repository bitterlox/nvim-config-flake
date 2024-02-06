# configurations means addons for now
{ pkgs, configurations }:
# configurations is "plugin" for some reason?????
let
  addon = import ../configurations/addons/addon.nix { inherit pkgs; };
  # there's an abstraction lurking here... when it works do it
  plugins = builtins.trace (builtins.trace "inner trace"
    (builtins.map addon.getPlugins configurations)) (pkgs.lib.lists.flatten
      (builtins.filter (e: e != null)
        (builtins.map addon.getPlugins configurations)));
  tools = builtins.trace (builtins.trace "tools"
    (builtins.attrNames (builtins.elemAt configurations 0)))
    (pkgs.lib.lists.flatten (builtins.filter (e: e != null)
      (builtins.map addon.getTools configurations)));
  luaFiles = builtins.map (pkg: "luafile ${pkg}") (pkgs.lib.lists.flatten
    (builtins.filter (e: e != [ ])
      (builtins.map addon.getLuaCfgs configurations)));
in builtins.trace (builtins.trace "trace from pkgcsm" configurations)
(pkgs.stdenv.mkDerivation { # add stuff to its paths
  name = "wrapped-nvim";
  # remove use of "with"
  src = with pkgs;
    wrapNeovim neovim-unwrapped {
      configure = {
        customRC = pkgs.lib.debug.traceSeqN 2 (builtins.trace "pkgcsm - luacfgs"
          (builtins.map (e: e.luaConfigs) configurations))
          (builtins.concatStringsSep "\n" luaFiles);
        packages = { all.start = plugins; };
      };
    };
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  installPhase =
    pkgs.lib.debug.traceSeqN 2 (builtins.trace "pkgcsm - tools" tools) (''
      makeWrapper $src/bin/nvim \
      $out/bin/nvim \
      --prefix PATH ":" ${pkgs.lib.makeBinPath tools}
    '');
})
