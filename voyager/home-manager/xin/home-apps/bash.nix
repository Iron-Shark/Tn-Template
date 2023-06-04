{ inputs, outputs, lib, config, pkgs, ... }: {

  programs.bash = {
    enable = true;

    shellAliases = {
      lx = "ls -la";
      rma = "rm -rf";
      power-off = "sudo shutdown -h now";
      logout = "sudo kill -9 -1";
      restart = "sudo reboot";
      eo = "emacsclient -n";
      seo = ''SUDO_EDITOR=\"emacsclient\" sudo -e'';
      rebuild = "bash ~/.config/system-scripts/flake-rebuild.sh";
      upgrade = "bash ~/.config/system-scripts/flake-upgrade.sh";
      rebuild-reboot = "rebuild && reboot";
      clean = "sudo nix-collect-garbage --delete-old && rebuild";
      reboot-clean = "sudo nix-collect-garbage --delete-old && rebuild-reboot";
      clipboard = "xclip -selection clipboard";
    };

    sessionVariables = {
      WEBKIT_DISABLE_COMPOSITING_MODE=1;
    };
  };
}
