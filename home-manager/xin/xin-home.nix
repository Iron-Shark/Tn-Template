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

  packages = with pkgs; [
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
  ];

  home.file = {
    "emacs" = {
      source = ./emacs;
      recursive = true;
      target = ".config/emacs";
    };
  };

  imports = [
    ./home-apps/home-manager.nix
    ./home-apps/bash.nix
    ./home-apps/git.nix
    ./home-apps/firefox.nix
  ];
}
