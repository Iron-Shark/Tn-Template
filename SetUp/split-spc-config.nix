{ config, pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
    ./que-specialisation.nix
    ./xin-specialisation.nix
    ./guest-specialisation.nix
  ];

  system.stateVersion = "22.05";

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixFlakes;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  users.mutableUsers = false;

  hardware.enableAllFirmware = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.initrd.preLVMCommands = "lvm vgchange -ay";

  security.sudo.wheelNeedsPassword = false;

  networking = {
    hostName = "vortex";
    networkmanager.enable = true;
  };

  services = {
    printing.enable = true;
    xserver = {
      enable = true;
      libinput.enable = true;
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  time.timeZone = "America/Detroit";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };

}
