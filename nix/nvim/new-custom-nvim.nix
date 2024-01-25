# A config-object has the form:
# {
#   addToPath: <derivation>
#   vimPlugin: <derivation>
#   luaConfig: <derivation>
# }
# provide constructors:
#   newToolConfig(<derivation>) -> { addToPath: <derivation> }
#   newPluginConfig(<derivation>) -> { vimPlugin: <derivation> }
#   newLuaConfig(<derivation>) -> { luaConfig: <derivation> }
# and helpers:
#   mergeConfigs({ addToPath?, vimPlugin?, luaConfig? }) -> returns merged object
#   getToolConfig(obj@{ addToPath?, vimPlugin?, luaConfig? }) -> returns obj.addToPath or nil
#   getPluginConfig(obj@{ addToPath?, vimPlugin?, luaConfig? }) -> returns obj.vimPlugin or nil
#   getLuaConfig(obj@{ addToPath?, vimPlugin?, luaConfig? }) -> returns obj.luaConfig or nil
# ----
# the code will work as follows:
# - big function gets the big list as param
# - we want to ed up with sublists, filtering with the get* functions and filtering again the nils out
# - for each list we do the required processing and we kosher
# 
{ pkgs, config-objects }:
let
in pkgs.stdenv.mkDerivation { # add stuff to its paths
  name = "wrapped-nvim";
  src = with pkgs;
    wrapNeovim neovim-unwrapped {
      configure = {
        # here will come your custom configuration
        customRC = rc;
        packages = { all.start = plugin-packages; };
      };
    };
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  installPhase = ''
    makeWrapper $src/bin/nvim \
      $out/bin/nvim \
      --prefix PATH ":" ${pkgs.lib.makeBinPath includeInPath}
  '';
}
