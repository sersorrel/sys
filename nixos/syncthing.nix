{ config, lib, pkgs, ... }:

{
  options = {
    sys.syncthing.openPorts = lib.mkOption {
      description = "Whether to open ports for Syncthing.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = {
    networking.firewall = {
      allowedTCPPorts = [ 22000 ];
      allowedUDPPorts = [ 22000 21027 ];
    };
  };
}
