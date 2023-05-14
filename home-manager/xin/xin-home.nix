{ inputs, outputs, lib, config, pkgs, ... }: {

  systemd.user.startServices = "sd-switch";

  home = {
    stateVersion = "22.11";
    homeDirectory = "/home/xin";
    username = "xin";

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

    file = {
      "emacs" = {
        source = ./emacs;
        recursive = true;
        target = ".config/emacs";
      };
    };
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

  programs = {
    home-manager.enable = true;
    bash.enable = true;
    import = ./home/git.nix;
    firefox = import ./home/firefox.nix;
  };

}
