{ inputs, outputs, lib, config, pkgs, ... }: {

  system.stateVersion = "22.11";

  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    ./default-specialisation.nix
    ./guest-specialisation.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
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
    picom.enable = true;
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

  environment = {
    etc = {
      secrets.source = ../secrets;
    };
    interactiveShellInit = ''
  alias lx='ls -la'
  alias rma='rm -rf'
  alias power-off='sudo shutdown -h now'
  alias logout='sudo kill -9 -1'
  alias restart='sudo reboot'
  alias eo='emacsclient -n'
  alias seo='SUDO_EDITOR=\"emacsclient\" sudo -e'
  alias voyager-rebuild='bash ~/.config/system-scripts/voyager-rebuild.sh'
  alias voyager-upgrade='bash ~/.config/system-scripts/voyager-upgrade.sh'
  alias voyager-rebuild-reboot='voyager-rebuild && reboot'
  alias voyager-clean='sudo nix-collect-garbage --delete-old && voyager-rebuild'
  alias voyager-clean-reboot='sudo nix-collect-garbage --delete-old && voyager-rebuild-reboot'
'';
  };

  fonts.fonts = with pkgs; [
    nerdfonts
    iosevka
    overpass
    fira-code
    fira-go
  ];

  users.users = {
    root = {
      passwordFile = "/etc/secrets/root/root-usrPasswd.nix";
    };
    xin = {
      isNormalUser = true;
      description = "Xin";
      extraGroups = [ "networkmanager" "wheel" ];
      passwordFile = "/etc/secrets/xin/xin-usrPasswd.nix";
    };
    que = {
      isNormalUser = true;
      description = "Xin";
      extraGroups = [ "networkmanager" "wheel" ];
      passwordFile = "/etc/secrets/que/que-usrPasswd.nix";
    };
    guest = {
      isNormalUser = true;
      description = "Guest";
      extraGroups = [ "networkmanager" ];
      passwordFile = "/etc/secrets/guest/guest-usrPasswd.nix";
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      xin = import ../home-manager/xin/xin-home.nix;
      que = import ../home-manager/que-home.nix;
      guest = import ../home-manager/guest-home.nix;
    };
  };

}
