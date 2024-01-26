{ pkgs, configurations }:
let
  # there's an abstraction lurking here... when it works do it
  plugins = builtins.filter (e: e != null)
    (builtins.map (cfg: cfg.vimPlugin) configurations);
  tools = builtins.filter (e: e != null)
    (builtins.map (cfg: cfg.addToPath) configurations);
  luaFiles = builtins.map (pkg: "luafile ${pkg}")
    (builtins.filter (e: e != null)
      (builtins.map (cfg: cfg.luaConfig) configurations));
in pkgs.stdenv.mkDerivation { # add stuff to its paths
  name = "wrapped-nvim";
  # remove use of "with"
  src = with pkgs;
    wrapNeovim neovim-unwrapped {
      configure = {
        customRC = builtins.concatStringsSep "\n" luaFiles;
        packages = { all.start = plugins; };
      };
    };
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  installPhase = ''
    makeWrapper $src/bin/nvim \
      $out/bin/nvim \
      --prefix PATH ":" ${pkgs.lib.makeBinPath tools}
  '';
}
