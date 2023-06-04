{ inputs, outputs, lib, config, pkgs, ... }: {

  systemd.user.startServices = "sd-switch";

  home = {
    stateVersion = "22.11";
    homeDirectory = "/home/xin";
    username = "xin";
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home.packages = with pkgs; [
    firefox
    gitFull
    git-crypt
    gh
    vim
    dropbox-cli
    openscad
    tridactyl-native
    hugo
    discord
    weechat
    alacritty
    exercism
    vlc
    bitwarden
    rbw
    gnupg
    xclip
    volctl
  ];

  imports = [
    ./home-apps/home-manager.nix
    ./home-apps/bash.nix
    ./home-apps/git.nix
    ./home-apps/firefox.nix
    ./home-apps/alacritty.nix
    ./home-apps/polybar.nix
    ./home-apps/emacs/emacs.nix
    ./system-scripts/flake-rebuild.nix
    ./system-scripts/flake-upgrade.nix
    ./system-scripts/flake-target.nix
  ];
}
