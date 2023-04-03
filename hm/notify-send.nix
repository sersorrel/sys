{ config, lib, pkgs, ... }:

{
  options = {
    sys.notify-send.enable = lib.mkOption {
      description = "Whether to install the notify-send CLI tool.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.notify-send.enable {
    home.packages = [ pkgs.libnotify ];
  };
}
