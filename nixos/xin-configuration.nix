{ inputs, outputs, lib, config, pkgs, callPackage, ... }: {

  specialisation.xin.configuration = {
    system.nixos.tags = [ "xin" ];

    services.xserver = {
      autorun = true;
      layout = "us";
      xkbVariant = "colemak_dh";
      xkbOptions = "caps:escape";
      desktopManager.gnome.enable = true;
      displayManager = {
        gdm.enable = true;
        autoLogin.enable = true;
        autoLogin.user = "xin";
      };

    };
    systemd.services = {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };

    environment.interactiveShellInit = ''
    alias lx='ls -la'
    alias logout='sudo kill -9 -1'
  '';

    users.users.root = {
      initialHashedPassword = "$6$KY5i2kUTspBbJUVy$2P5N9ks4kNpW5iKRRCNUX9FmTvwUKC4mkPfpWchiBFMuBHHJoa2/le4H3KxhYGOs/w6d4nQeFJIz/s9XnCjIJ0";
    };

    users.users.xin = {
      isNormalUser = true;
      description = "Xin";
      uid = 1002;
      extraGroups = [ "networkmanager" "wheel" ];
      initialHashedPassword = "$6$KY5i2kUTspBbJUVy$2P5N9ks4kNpW5iKRRCNUX9FmTvwUKC4mkPfpWchiBFMuBHHJoa2/le4H3KxhYGOs/w6d4nQeFJIz/s9XnCjIJ0";
    };

    home-manager = {
      extraSpecialArgs = { inherit inputs outputs; };
      users = {
        xin = import ../home-manager/xin-home.nix;
      };
    };

    services.emacs = {
      enable = true;
      package = pkgs.emacsUnstable;
    };
    environment.systemPackages = [
      (emacsWithPackagesFromUsePackage {
        package = pkgs.emacsUnstable;
        # Your Emacs config file. Org mode babel files are also
        # supported.
        # NB: Config files cannot contain unicode characters, since
        #     they're being parsed in nix, which lacks unicode
        #     support.
        # config = ./emacs.org;
        config = ./emacs.el;
        defaultInitFile = true;
        alwaysEnsure = true;
        # extraEmacsPackages = epkgs: [
        #   epkgs.packageName
        # ];
      })
    ];

  };
}
