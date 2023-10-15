{ pkgs }: pkgs.stdenv.mkDerivation {
  name = "lua";
  src = ../../lua/config;
  installPhase = ''
    mkdir -p $out/
    cp -r $src/* $out/
  ''; 
}
