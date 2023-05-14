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
          extraPackages = epkgs: with epkgs; [
            use-package
            exwm
            burly
            helm
            helm-projectile
            emojify
            all-the-icons
            ligature
            centered-cursor-mode
            rainbow-delimiters
            smartparens
            doom-modeline
            doom-themes
            evil
            evil-snipe
            evil-easymotion
            evil-collection
            evil-colemak-basics
            helpful
            which-key
            undo-tree
            dmenu
            magit
            git-gutter
            projectile
            ag
            rg
            nix-mode
            org-bullets
            org-appear
            org
            ox-hugo
            visual-fill-column
            aggressive-indent
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
      # I'm leaving this here for later reference
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
