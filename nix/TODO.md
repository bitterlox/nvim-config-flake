# TODO:

so here's how it will go down

addons/
declares the "addon.nix" interface
declares the config.neovim.editors module option
has all the addons in subfolders (so like, lsps, themes, etc.)
Can probably also move packages/ in here, as an addons subfolder

configurations/
imports addons from addons/ and defines different instances of editors
in config.neovim.editors. Maybe we move custom-nvim to here and have
the code to build the thing as well
