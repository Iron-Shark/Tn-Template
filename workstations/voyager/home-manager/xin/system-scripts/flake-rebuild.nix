{ inputs, outputs, lib, config, pkgs, ... }: {

  home.file."flake-rebuild.sh" = {
    target = ".config/system-scripts/flake-rebuild.sh";
    executable = true;
    text = ''
    #!/bin/sh

    cd ~/.nix-flake-target
    git add .
    git commit -m "Rebuilding $HOSTNAME"
    git push
    sudo nixos-rebuild switch --flake .#$HOSTNAME
    cd -
  '';
  };
}
