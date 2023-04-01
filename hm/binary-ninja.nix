{ config, lib, pkgs, ... }:

{
  options = {
    sys.binary-ninja.enable = lib.mkOption {
      description = "Whether to install Binary Ninja, a binary analysis platform.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.binary-ninja.enable {
    home.packages = [ pkgs.binary-ninja ];
  };
}
