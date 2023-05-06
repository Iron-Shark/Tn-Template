# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # This value determines the NixOS release from which the default settings for stateful data.
  system.stateVersion = "22.05";

  hardware.enableAllFirmware = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "vortex"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Detroit";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Disable requiring SUDO password by users.
  security.sudo.wheelNeedsPassword = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "colemak_dh";
  };
  services.xserver.xkbOptions = "caps:swapescape";
  console.useXkbConfig = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pulseAudio.
  hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  sound.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    # Web Tools
    firefox  # Must stay at system Level
    gitFull
    vim  # Must stay at system Level
    pulseaudio
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix = {
    package = pkgs.nixFlakes;
  };

  environment.interactiveShellInit = ''
    alias lx='ls -la'
    alias logout='sudo kill -9 -1'
  '';

  specialisation = {
    que.configuration = {
      system.nixos.tags = [ "que" ];
      # xserver settings go here. Unless they can be configured with home-manager
      users.users.que = {
        isNormalUser = true;
        # description = "Que";
        uid = 1001;
        extraGroups = [ "networkmanager" "wheel" ];
        # packages = with pkgs; [   Unless packages can be only managed with Home-manager
        # ];
        };
      services.xserver.displayManager.autoLogin = {
        enable = true;
        user = "que";
      };
    };

    xin.configuration = {
      system.nixos.tags = [ "xin" ];
      services.xserver.desktopManager.gnome.enable = true;
      users.users.xin = {
        isNormalUser = true;
        uid = 1002;
        extraGroups = [ "networkmanager" "wheel" ];
      };
      services.xserver.displayManager.autoLogin = {
        enable = true;
        user = "xin";
      };
      environment.systemPackages = with pkgs; [
        hello # This is where you install system packages, unless the above can be shared by all spec
      ];
    };
  };

}
