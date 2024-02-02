{ pkgs }:
let addon = import ../addon.nix;
in addon.makePluginAddon {
    pkg = [ pkgs.vimPlugins.tmux-nvim ];
    config = [ ../lua/config/plugins/plugin-config/tmux-nvim.lua ];
}
