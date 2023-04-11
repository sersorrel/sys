{ config, lib, ... }:

{
  options = {
    sys.fragments.openPorts = lib.mkOption {
      description = "Whether to open ports for Fragments.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.fragments.openPorts {
    networking.firewall = {
      allowedTCPPorts = [ 51413 ];
      allowedUDPPorts = [ 51413 ];
    };
  };
}
