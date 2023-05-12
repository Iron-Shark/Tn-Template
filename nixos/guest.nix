({ inputs, outputs, lib, config, pkgs, ... }: {
  config = lib.mkIf (config.specialisation != {}) {

    services.xserver = {
      autorun = true;
      layout = "us";
      desktopManager.gnome.enable = true;
      displayManager = {
        gdm.enable = true;
        autoLogin.enable = true;
        autoLogin.user = "guest";
      };
    };

    systemd.services = {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };

    environment.systemPackages = with pkgs; [
      firefox
      git
      vim
    ];
    environment.interactiveShellInit = ''
    alias lx='ls -la'
    alias logout='sudo kill -9 -1'
  '';
  };
})
