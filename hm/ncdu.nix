{ config, lib, pkgs, ... }:

{
  options = {
    sys.ncdu.enable = lib.mkOption {
      description = "Whether to install ncdu, a command-line disk usage viewer.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.ncdu.enable {
    home.packages = [ pkgs.ncdu ];
    xdg.configFile."ncdu/config".text = ''
      --color=off
    '';
  };
}
