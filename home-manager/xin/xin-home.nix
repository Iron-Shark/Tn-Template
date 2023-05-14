{ inputs, outputs, lib, config, pkgs, ... }: {

  home.stateVersion = "22.11";
  programs = {
    home-manager.enable = true;
    bash.enable = true;
  };

  home = {
    username = "xin";
    homeDirectory = "/home/xin";
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

  programs.git = {
    enable = true;
    import ./home/git.nix;
  };

  programs.firefox = {
    enable = true;
    import ./home/firefox.nix;
  };

  home.file."emacs" = {
    source = ./emacs;
    recursive = true;
    target = ".config/emacs";
  };

}
