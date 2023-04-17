{ config, lib, pkgs, ... }:

{
  options = {
    sys.gamepads.enable = lib.mkOption {
      description = "Whether to enable support for gamepads (e.g. the Nintendo Pro Controller).";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.gamepads.enable {
    services.joycond.enable = true;
  };
}