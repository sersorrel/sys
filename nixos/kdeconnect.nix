{ config, lib, ... }:

{
  options = {
    sys.kdeconnect.openPorts = lib.mkOption {
      description = "Whether to open ports for KDE Connect.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.kdeconnect.openPorts {
    networking.firewall = {
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
      allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
    };
  };
}
