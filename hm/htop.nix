{ config, lib, pkgs, ... }:

{
  options = {
    sys.htop.enable = lib.mkOption {
      description = "Whether to install htop, a terminal process monitor.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.htop.enable {
    home.packages = [ pkgs.htop ];
  };
}
