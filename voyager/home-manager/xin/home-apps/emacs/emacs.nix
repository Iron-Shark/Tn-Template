{ inputs, outputs, lib, config, pkgs, ... }: {

  home.file.emacs-init = {
    source = ./init.el;
    target = ".config/emacs/init.el";
  };

  home.file.emacs-bookmarks = {
    source = config.lib.file.mkOutOfStoreSymlink ./bookmarks;
    target = ".config/emacs/bookmarks";
  };
}
