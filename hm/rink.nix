{ config, lib, pkgs, ... }:

{
  options = {
    sys.rink.enable = lib.mkOption {
      description = "Whether to install Rink, a unit-aware calculator.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.rink.enable {
    home.packages = [ pkgs.rink ];
  };
}
