{ config, lib, pkgs, ... }:

{
  options = {
    sys.obs.enable = lib.mkOption {
      description = "Whether to install OBS, the Open Broadcaster Software.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.obs.enable {
    home.packages = [ pkgs.obs-studio ];
  };
}
