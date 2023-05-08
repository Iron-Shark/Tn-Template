({ lib, config, pkgs, ...}: {
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

    users.users.root = {
      initialHashedPassword = "$6$KY5i2kUTspBbJUVy$2P5N9ks4kNpW5iKRRCNUX9FmTvwUKC4mkPfpWchiBFMuBHHJoa2/le4H3KxhYGOs/w6d4nQeFJIz/s9XnCjIJ0";
    };

    users.users.guest = {
      isNormalUser = true;
      description = "Guest";
      uid = 1003;
      extraGroups = [ "networkmanager" "wheel" ];
      initialHashedPassword = "$6$GixqRZ1inXxpl7gA$ZYKTjsfJYowMuLMO329FSHc5hPHDjvgGfJVequ4BWUQx3hf85baGkSiBKAwr0x/tc2qf1dVZZq4.3yTxmddqb/";
    };
  };
})
