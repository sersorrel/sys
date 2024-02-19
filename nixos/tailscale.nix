{ config, lib, pkgs, ... }:

{
  options = {
    sys.tailscale.enable = lib.mkOption {
      description = "Whether to enable Tailscale, a VPN client.";
      type = lib.types.bool;
      default = true;
    };
    sys.tailscale.tailnets = lib.mkOption {
      description = "Tailnet names (not including `.ts.net`) to use for MagicDNS.";
      type = lib.types.listOf (lib.types.strMatching "[a-z]+-[a-z]+|tail[0-9a-f]+");
      default = [];
    };
  };
  config = let
    sd = xs: pkgs.writeText "searchdomains" (
      lib.concatStrings (map (s: "search ${s}.ts.net\n") xs)
    );
  in lib.mkIf config.sys.tailscale.enable {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = lib.mkDefault "client";
    };
    systemd.network.wait-online.ignoredInterfaces = [ config.services.tailscale.interfaceName ];
  };
}
