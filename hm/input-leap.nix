{ config, lib, pkgs, ... }:

{
  options = {
    sys.input-leap.enable = lib.mkOption {
      description = "Whether to install Input Leap, a software KVM switch.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.input-leap.enable {
    home.packages = [ pkgs.input-leap ];
  };
}
