{ config, lib, ... }:

{
  options = {
    sys.appimage.enable = lib.mkOption {
      description = "Whether to enable support for running appimages with appimage-run.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.appimage.enable {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
