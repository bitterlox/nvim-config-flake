
## This code has been merged into my main nixos.config repo

---

# config files

  we have three ways of adding lua config files:
  - plugins/lua/plugin-config/: need to be of the same name as an installed
    package, will be loaded according to the order in which that package
    is in the packageNames list in default.nix
  - plugins/lua/keybindings: same rules as above, is loaded right after
    that file if present
  - plugins/lua/extra-config: no special rules for filenames here, are
    loaded after all the plugin-specific config
