{ config, lib, ... }:

{
  options = {
    sys.autorandr.enable = lib.mkOption {
      description = "Whether to enable autorandr, a script to automatically configure monitor layout under X11.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.autorandr.enable {
    services.autorandr.enable = true;
  };
}
