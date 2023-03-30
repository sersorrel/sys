{ config, lib, pkgs, ... }:

{
  options = {
    sys.ffmpeg-full.enable = lib.mkOption {
      description = "Whether to install an ffmpeg with additional features enabled.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.ffmpeg-full.enable {
    home.packages = [
      (pkgs.ffmpeg-full.override {
        withUnfree = true;
        withFdkAac = true;
      })
    ];
  };
}
