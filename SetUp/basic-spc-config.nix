{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ];

  system.stateVersion = "22.05";

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixFlakes;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

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
        users.mutableUsers = false;
        users.users.root = {
          password = "root";
        };
          users.users.que = {
            isNormalUser = true;
            description = "Que";
            uid = 1001;
            extraGroups = [ "networkmanager" "wheel" ];
            initialHashedPassword = "que";
          };
      };
      xin.configuration = {
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
          password = "root";
        };
        users.users.xin = {
          isNormalUser = true;
          description = "Xin";
          uid = 1002;
          extraGroups = [ "networkmanager" "wheel" ];
          initialHashedPassword = "xin";
        };
      };
      guest.configuration = {
        system.nixos.tags = [ "guest" ];
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
        users.users.guest = {
          isNormalUser = true;
          description = "Guest";
          uid = 1003;
          extraGroups = [ "networkmanager" ];
          initialHashedPassword = "guest";
        };
      };
    };

  }
