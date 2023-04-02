{ config, lib, pkgs, ... }:

{
  options = {
    sys.gnome-tracker.enable = lib.mkOption {
      description = "Whether to enable GNOME Tracker, a filesystem indexing daemon.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.gnome-tracker.enable {
    services.gnome = {
      tracker.enable = true;
      tracker-miners.enable = true;
    };
  };
}
