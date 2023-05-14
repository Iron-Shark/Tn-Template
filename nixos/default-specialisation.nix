({ inputs, outputs, lib, config, pkgs, ... }: {
  config = lib.mkIf (config.specialisation != {}) {

    services = {

      unclutter-xfixes.enable = true;

      cron = {
        enable = true;
        systemCronJobs = [
          "*/5 * * * *      root    date >> /tmp/cron.log"
        ];
      };

      xserver = {
        autorun = true;
        layout = "us";
        xkbVariant = "colemak_dh";
        xkbOptions = "caps:escape";

        displayManager = {
          sddm.enable = true;
          sddm.autoNumlock = true;
        };

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
      };
    };

    environment.systemPackages = with pkgs; [
      # pulseaudio
      # pulseaudio-ctl
      # pulsemixer
      polybar
      networkmanagerapplet
      volctl
      lm_sensors
      pciutils
      fd
      silver-searcher
      wget
      unzip
      hunspell
      hunspellDicts.en_US-large
      slock
      flameshot
    ];
  };
})
