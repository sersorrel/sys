{ config, lib, options, ... }:

{
  options = {
    sys.gammastep.enable = lib.mkOption {
      description = "Whether to enable gammastep, a screen colour temperature manager.";
      type = lib.types.bool;
      default = false;
    };
    sys.gammastep.latitude = lib.mkOption {
      description = "Latitude, between -90 and 90.";
      type = options.services.gammastep.latitude.type;
      default = null;
    };
    sys.gammastep.longitude = lib.mkOption {
      description = "Longitude, between -180 and 180.";
      type = options.services.gammastep.longitude.type;
      default = null;
    };
  };
  config = lib.mkIf config.sys.gammastep.enable {
    services.gammastep = {
      enable = true;
      tray = true;
      temperature.day = 6500;
      temperature.night = 3600;
      inherit (config.sys.gammastep) latitude longitude;
    };
  };
}
