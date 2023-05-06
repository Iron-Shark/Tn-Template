{ inputs, outputs, lib, config, pkgs, ... }: {

  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  networking.hostName = "TEST-Name";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      que = import ../home-manager/vm.nix;
    };
  };

  users.users = {
    que = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
     };
  };

  time.timeZone = "America/Detroit";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
