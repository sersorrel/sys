{ config, lib, ... }:

{
  options = {
    sys.kdeconnect.enable = lib.mkOption {
      description = "Whether to enable KDE Connect.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.kdeconnect.enable {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
