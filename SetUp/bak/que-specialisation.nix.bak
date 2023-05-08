{ config, pkgs, ... }: {

  specialisation.que.configuration = {
    system.nixos.tags = [ "que" ];

    services.xserver = {
      autorun = true;
      layout = "us";
      xkbVariant = "colemak_dh";
      xkbOptions = "caps:escape";
      desktopManager.gnome.enable = true;
      displayManager = {
        gdm.enable = true;
        autoLogin.enable = true;
        autoLogin.user = "que";
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

    users.users.que = {
      isNormalUser = true;
      description = "Que";
      uid = 1001;
      extraGroups = [ "networkmanager" "wheel" ];
      initialHashedPassword = "$6$KY5i2kUTspBbJUVy$2P5N9ks4kNpW5iKRRCNUX9FmTvwUKC4mkPfpWchiBFMuBHHJoa2/le4H3KxhYGOs/w6d4nQeFJIz/s9XnCjIJ0";
    };
  };

}
