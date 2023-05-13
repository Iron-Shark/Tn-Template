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
    networkmanagerapplet
    volctl
    pulseaudio
    pulseaudio-ctl
    pulsemixer
    ############
    lm_sensors
    pciutils
    unzip
    hunspell
    hunspellDicts.en_US-large
    slock
    flameshot
    dropbox-cli
    polybar
    openscad
    fd
    silver-searcher
    wget
    tridactyl-native
    hugo
    discord
    weechat
    alacritty
    exercism
    vlc
  ];

  programs.git = {
    package = pkgs.gitFull;
    enable = true;
    lfs.enable = true;
    userName = "Que";
    userEmail = "git@ironshark.org";
    ignores = [
      "*~"
      ".*~"
      "#*#"
      "'#*#'"
      ".*.swp"
    ];
    aliases = {
      send = "! git status &&
echo -n \"Commit Message: \" &&
read -r commitMessage &&
git add . &&
git commit -m \"$commitMessage\" &&
git push";
    };
    extraConfig = {
      init = {
        defaultBranch = "main";
        pull = {
          rebase = true;
        };
      };
    };
  };

  home.file."emacs" = {
    source = ./emacs;
    recursive = true;
    target = ".config/emacs";
  };

}
