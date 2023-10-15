{ pkgs }:
let
  inherit (pkgs)
    gopls lua-language-server rust-analyzer efm-langserver nixd shellharden
    yamllint stylua;
  inherit (pkgs.nodePackages)
    bash-language-server typescript-language-server jsonlint markdownlint-cli;
in pkgs.stdenv.mkDerivation {
  name = "lua-env";
  src = pkgs.writeText "env.lua" ''
    vim.g.env = {
      lsp_paths = {
        gopls = "${gopls}",
        luals = "${lua-language-server}",
        rust_analyzer = "${rust-analyzer}",
        efm_langserver = "${efm-langserver}",
        nixd = "${nixd}",
        tsserver = "${typescript-language-server}",
        bashls = "${bash-language-server}",
      },
      efm_tools_paths = {
        shellharden = "${shellharden}",
        yamllint = "${yamllint}",
        stylua = "${stylua}",
        jsonlint = "${jsonlint}",
        markdownlint = "${markdownlint-cli}",
      }
    }
  '';
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/env.lua
  '';
}
