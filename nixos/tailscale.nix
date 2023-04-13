{ config, lib, ... }:

{
  options = {
    sys.tailscale.enable = lib.mkOption {
      description = "Whether to enable Tailscale, a VPN client.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.tailscale.enable {
    services.tailscale.enable = true;
    systemd.network.wait-online.ignoredInterfaces = [ "tailscale0" ];
  };
}
