{ config, lib, ... }:

{
  options = {
    sys.avahi.enable = lib.mkOption {
      description = "Whether to enable Avahi, a zeroconf implementation to allow service discovery on the local network.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.avahi.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
    };
  };
}
