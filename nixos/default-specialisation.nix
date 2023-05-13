({ inputs, outputs, lib, config, pkgs, ... }: {
  config = lib.mkIf (config.specialisation != {}) {

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


    services.emacs = {
      enable = true;
      install = true;
      defaultEditor = true;
      package = (pkgs.emacsWithPackagesFromUsePackage {
        config = ./emacs.el;
        package = pkgs.emacsUnstable;
        alwaysEnsure = true;
        extraEmacsPackages = epkgs: [
          epkgs.use-package
        ];
      });
    };

    };
})
