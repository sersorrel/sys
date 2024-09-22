{ config, lib, pkgs, ... }:

{
  options = {
    sys.speedcrunch.enable = lib.mkOption {
      description = "Whether to install SpeedCrunch, a calculator.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.speedcrunch.enable {
    home.packages = [ pkgs.speedcrunch ];
  };
}
