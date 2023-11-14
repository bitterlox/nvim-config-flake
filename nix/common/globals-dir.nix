{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "globals";
  src = ../../lua/globals;
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src/* $out
  '';
}
