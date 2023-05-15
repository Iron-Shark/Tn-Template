{ inputs, outputs, lib, config, pkgs, ... }: {

  home.file.flake-target = {
    source = config.lib.file.mkOutOfStoreSymlink ../../../../Tn-Template;
    recursive = true;
    target = ".flake-target";
  };
}
