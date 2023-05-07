specialisation = {
  que.configuration = {
    system.nixos.tags = [ "que" ];
    # xserver settings go here. Unless they can be configured with home-manager
    services.xserver = {
      autorun = true;
      layout = "us";
      xkbVariant = "colemak_dh";
      xkbOptions = "caps:escape";
      desktopManager.gnome.enable = true;
      displayManager = {
        gdm.enable = true;
        autoLogin.enable = true;
        autoLogin.user = "que"
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
    users.users.que = {
      isNormalUser = true;
      description = "Que";
      uid = 1001;
      extraGroups = [ "networkmanager" "wheel" ];
    };
  };
};
