{ config, lib, ... }:

{
  options = {
    sys.flameshot.enable = lib.mkOption {
      description = "Whether to enable Flameshot, a screenshot application.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.flameshot.enable {
    services.flameshot.enable = true;
  };
}
