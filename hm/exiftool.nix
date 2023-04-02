{ config, lib, pkgs, ... }:

{
  options = {
    sys.exiftool.enable = lib.mkOption {
      description = "Whether to install ExifTool, a metadata manipulation program.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.exiftool.enable {
    home.packages = [ pkgs.exiftool ];
  };
}
