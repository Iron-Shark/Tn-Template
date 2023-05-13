{ inputs, outputs, lib, config, pkgs, ... }: {

  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    ./default-specialisation.nix
    ./guest-specialisation.nix
  ];

  system.stateVersion = "22.05";

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      inputs.emacs-community.overlay
    ];
    config = {
      allowUnfree = true;
    };
    hostPlatform = lib.mkDefault "x86_64-linux";
  };

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };

    security = {
      sudo.wheelNeedsPassword = false;
      rtkit.enable = true;
    };

    networking = {
      hostName = "vortex";
      networkmanager.enable = true;
      useDHCP = lib.mkDefault true;
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

    users.users.root = {
      hashedPassword = "$6$KY5i2kUTspBbJUVy$2P5N9ks4kNpW5iKRRCNUX9FmTvwUKC4mkPfpWchiBFMuBHHJoa2/le4H3KxhYGOs/w6d4nQeFJIz/s9XnCjIJ0";
    };

    users.users = {
      xin = {
        isNormalUser = true;
        description = "Xin";
        uid = 1001;
        extraGroups = [ "networkmanager" "wheel" ];
        passwordFile = "./xin-secrets.nix";
        # hashedPassword = "$6$KY5i2kUTspBbJUVy$2P5N9ks4kNpW5iKRRCNUX9FmTvwUKC4mkPfpWchiBFMuBHHJoa2/le4H3KxhYGOs/w6d4nQeFJIz/s9XnCjIJ0";
      };
      que = {
        isNormalUser = true;
        description = "Xin";
        uid = 1003;
        extraGroups = [ "networkmanager" "wheel" ];
        hashedPassword = "$6$KY5i2kUTspBbJUVy$2P5N9ks4kNpW5iKRRCNUX9FmTvwUKC4mkPfpWchiBFMuBHHJoa2/le4H3KxhYGOs/w6d4nQeFJIz/s9XnCjIJ0";
      };
      guest = {
        isNormalUser = true;
        description = "Guest";
        uid = 1002;
        extraGroups = [ "networkmanager" ];
        initialHashedPassword = "$6$GixqRZ1inXxpl7gA$ZYKTjsfJYowMuLMO329FSHc5hPHDjvgGfJVequ4BWUQx3hf85baGkSiBKAwr0x/tc2qf1dVZZq4.3yTxmddqb/";
      };
    };

    home-manager = {
      extraSpecialArgs = { inherit inputs outputs; };
      users = {
        xin = import ../home-manager/xin-home.nix;
        que = import ../home-manager/que-home.nix;
        guest = import ../home-manager/guest-home.nix;
      };
    };
}
