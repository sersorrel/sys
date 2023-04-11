{ config, lib, ... }:

{
  options = {
    sys.rasdaemon.enable = lib.mkOption {
      description = "Whether to enable rasdaemon, which monitors and logs hardware issues like MCEs and ECC errors.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.rasdaemon.enable {
    hardware.rasdaemon.enable = true;
  };
}
