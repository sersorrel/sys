{ config, lib, pkgs, ... }:

{
  options = {
    sys.android-studio.enable = lib.mkOption {
      description = "Whether to install Android Studio.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.android-studio.enable {
    home.packages = [ pkgs.android-studio ];
  };
}
