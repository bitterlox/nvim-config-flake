{ pkgs }: pkgs.stdenv.mkDerivation {
    name = "globals";
    dynamicEnvSrc = import ./dynamic-env.nix { inherit pkgs; };
    src = ../../lua/globals;
    dontUnpack = true;
    installPhase = ''
      mkdir $out
      cp $src/* $out
      cp $dynamicEnvSrc $out/env.lua
    '';
  }
