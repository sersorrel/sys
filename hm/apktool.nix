{ config, lib, pkgs, ... }:

{
  options = {
    sys.apktool.enable = lib.mkOption {
      description = "Whether to install apktool, an Android APK decompiler.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.apktool.enable {
    home.packages = [ pkgs.apktool ];
  };
}
