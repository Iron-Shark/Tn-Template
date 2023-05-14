({ inputs, outputs, lib, config, pkgs, ... }: {
  config = lib.mkIf (config.specialisation != {}) {

    services = {
      unclutter-xfixes.enable = true;
      xserver = {
        autorun = true;
        layout = "us";
        xkbVariant = "colemak_dh";
        xkbOptions = "caps:escape";
        windowManager.exwm = {
          enable = true;
          enableDefaultConfig = false;
          package = pkges.emacsUnstable;
          alwaysEnable = true;
          extraPackages = epkgs: [
            epkgs.use-package
          ];
        };
        displayManager = {
          sddm.enable = true;
          sddm.autoNumlock = true;
        };
      };
      cron = {
        enable = true;
        systemCronJobs = [
          "*/5 * * * *      root    date >> /tmp/cron.log"
        ];
      };
      # emacs = {
      #   enable = true;
      #   install = true;
      #   defaultEditor = true;
      #   package = (pkgs.unstable.emacsWithPackagesFromUsePackage {
      #     config = ~/.config/init.el;
      #     package = pkgs.emacsUnstable;
      #     alwaysEnsure = true;
      #     extraEmacsPackages = epkgs: [
      #       epkgs.use-package
      #     ];
      #   });
      #   };
    };
  };
})
