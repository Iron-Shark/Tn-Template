{ inputs, outputs, lib, config, pkgs, ... }:

let
  my-emacs = pkgs.emacsWithPackagesFromUsePackage {
    config = ./emacs/init.el;
    package = pkgs.emacsUnstable;
    alwaysEnsure = true;
    extraEmacsPackages = epkgs: [
      epkgs.use-package
      epkgs.exwm
    ];
  };

  exwm-load-script = pkgs.writeText "exwm-load.el" ''
    (progn
      (require 'exwm)
      (exwm-init))
  '';


in {
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
      inputs.emacs-community.overlay
    ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  systemd.user.startServices = "sd-switch";


    xsession = {
      enable = true;
      windowManager.command = ''
          ${my-emacs}/bin/emacs -l "${exwm-load-script}"
         '';
      initExtra = ''
      xset r rate 200 100
    '';
    };

    home.packages = with pkgs; [
      my-emacs
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
