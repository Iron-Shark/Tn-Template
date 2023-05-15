{ inputs, outputs, lib, config, pkgs, ... }: {

  home.file.emacs = {
    source = ../emacs;
    recursive = true;
    target = ".config/emacs";
  };
}
