configuration = {
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
      autoLogin.user = "xin"
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
  users.users.xin = {
    isNormalUser = true;
    description = "Xin";
    uid = 1002;
    extraGroups = [ "networkmanager" "wheel" ];
  };
};
