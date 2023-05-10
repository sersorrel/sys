{ config, lib, pkgs, ... }:

{
  options = {
    sys.input-leap.openPorts = lib.mkOption {
      description = "Whether to open ports for Input Leap.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.input-leap.openPorts {
    networking.firewall.allowedTCPPorts = [ 24800 ];
  };
}
