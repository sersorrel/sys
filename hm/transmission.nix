{ config, lib, pkgs, ... }:

{
  options = {
    sys.transmission.enable = lib.mkOption {
      description = "Whether to install Transmission, a BitTorrent client.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.transmission.enable {
    home.packages = [ pkgs.transmission_4-qt ];
  };
}
