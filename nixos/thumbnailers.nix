{ config, lib, ... }:

{
  options = {
    sys.thumbnailers.enable = lib.mkOption {
      description = "Whether to enable a thumbnailer.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.thumbnailers.enable {
    services.tumbler.enable = true;
  };
}
