{ inputs, outputs, lib, config, pkgs, ... }: {

  home.file."flake-upgrade.sh" = {
    target = ".config/system-scripts/flake-upgrade.sh";
    executable = true;
    text = ''
    #!/bin/sh

    cd ~/.nix-flake-target
    git add .
    git commit -m "Upgrading $HOSTNAME"
    git push
    sudo nix flake update
    sudo nixos-rebuild switch --flake .#$HOSTNAME --upgrade
    cd -
  '';
  };
