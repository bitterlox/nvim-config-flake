# this is a flake-parts module
{ ... }: {
  imports = [ ./packages ./options.nix ./nvim ];
}
