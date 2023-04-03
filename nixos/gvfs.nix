{ config, lib, ... }:

{
  options = {
    sys.gvfs.enable = lib.mkOption {
      description = "Whether to enable gvfs, a userspace virtual filesystem implementation.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.gvfs.enable {
    services.gvfs.enable = true;
  };
}
