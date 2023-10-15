{ pkgs }:
let
  inherit (pkgs)
    gopls lua-language-server rust-analyzer efm-langserver nil shellharden
    yamllint stylua nixfmt;
  inherit (pkgs.nodePackages)
    bash-language-server typescript-language-server jsonlint markdownlint-cli;
in pkgs.writeText "env.lua" ''
  vim.g.env = {
    lsp_paths = {
      gopls = "${gopls}/bin/gopls",
      luals = "${lua-language-server}/bin/lua-language-server",
      rust_analyzer = "${rust-analyzer}/bin/rust-analyzer",
      efm_langserver = "${efm-langserver}/bin/efm-langserver",
      [ "nil" ] = "${nil}/bin/nil",
      tsserver = "${typescript-language-server}/bin/typescript-language-server",
      bashls = "${bash-language-server}/bin/bash-language-server",
    },
    efm_tools_paths = {
      shellharden = "${shellharden}/bin/shellharden",
      yamllint = "${yamllint}/bin/yamllint",
      stylua = "${stylua}/bin/stylua",
      jsonlint = "${jsonlint}/bin/jsonlint",
      markdownlint = "${markdownlint-cli}/bin/markdownlint",
    },
    tools = {
      nixfmt = "${nixfmt}/bin/nixfmt"
    }
  }
''
