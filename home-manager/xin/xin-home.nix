{ inputs, outputs, lib, config, pkgs, ... }: {

  home = {
    stateVersion = "22.11";
    homeDirectory = "/home/xin";
    username = "xin";
  };

  programs = {
    home-manager.enable = true;
    bash.enable = true;
    git = import ./home/git.nix;
    firefox = import ./home/firefox.nix;
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

  systemd.user.startServices = "sd-switch";

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
  ];

  home.file."emacs" = {
    source = ./emacs;
    recursive = true;
    target = ".config/emacs";
  };

}
