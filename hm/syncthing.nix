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
    systemd.user.targets.tray = {
      # Workaround for "Unit tray.target not found" when starting e.g. flameshot
      # https://github.com/nix-community/home-manager/issues/2064
      Unit = {
        Description = "Fake tray target (workaround for home-manager problem)";
        Requires = [ "graphical-session-pre.target" ];
      };
    };
  };
}
