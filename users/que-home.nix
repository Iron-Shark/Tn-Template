{ inputs, outputs, lib, config, pkgs, ... }: {

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "que";
    homeDirectory = "/home/que";
  };

  home.packages = with pkgs; [ emacs ];

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
