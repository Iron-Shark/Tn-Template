({ inputs, outputs, lib, config, pkgs, ... }: {
  config = lib.mkIf (config.specialisation != {}) {

    services = {
      unclutter-xfixes.enable = true;
      xserver = {
        autorun = true;
        layout = "us";
        xkbVariant = "colemak_dh";
        xkbOptions = "caps:escape";
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
    };
  };

})
