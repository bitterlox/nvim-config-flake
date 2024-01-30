{ pkgs }:
let
  addon = import ../addon.nix;
  lspsFn = import ./lsps;
in {
  # lsps
  lsps = lspsFn pkgs;

  # linters
  yamllint = addon.makeToolAddon { pkg = pkgs.yamllint; };
  jsonlint = addon.makeToolAddon { pkg = pkgs.nodePackages.jsonlint; };
  markdownlint-cli =
    addon.makeToolAddon { pkg = pkgs.nodePackages.markdownlint-cli; };

  # formatters
  shellharden = addon.makeToolAddon { pkg = pkgs.shellharden; };
  stylua = addon.makeToolAddon { pkg = pkgs.stylua; };
  nixfmt = addon.makeToolAddon { pkg = pkgs.nixfmt; };

  # misc
  ripgrep = addon.makeToolAddon { pkg = pkgs.ripgrep; };
  fd = addon.makeToolAddon { pkg = pkgs.fd; };
}
