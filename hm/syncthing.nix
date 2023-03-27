{ config, lib, pkgs, ... }:

{
  options = {
    sys.syncthing.enable = lib.mkOption {
      description = "Whether to enable Syncthing, a file syncing application.";
      type = lib.types.bool;
      default = false;
    };
    sys.syncthing.enableTray = lib.mkOption {
      description = "Whether to enable tray applet for Syncthing.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.syncthing.enable {
    services.syncthing = {
      enable = true;
      tray = lib.mkIf config.sys.syncthing.enableTray {
        enable = true;
        package = pkgs.syncthingtray;
        command = "syncthingtray --wait";
      };
    };
  };
}
