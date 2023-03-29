{ config, lib, pkgs, ... }:

{
  options = {
    sys.playerctl.enable = lib.mkOption {
      description = "Whether to enable playerctl, a command-line MPRIS controller and daemon.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.playerctl.enable {
    home.packages = [ pkgs.playerctl ];
    services.playerctld.enable = true;
  };
}
