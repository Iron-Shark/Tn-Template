{ config, pkgs, ... }: {

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

      users.users.xin = {
        isNormalUser = true;
        description = "Xin";
        uid = 1002;
        extraGroups = [ "networkmanager" "wheel" ];
        initialHashedPassword = "$6$KY5i2kUTspBbJUVy$2P5N9ks4kNpW5iKRRCNUX9FmTvwUKC4mkPfpWchiBFMuBHHJoa2/le4H3KxhYGOs/w6d4nQeFJIz/s9XnCjIJ0";
      };
    };

}
