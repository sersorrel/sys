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
    services.tailscale.enable = true;
    systemd.network.wait-online.ignoredInterfaces = [ config.services.tailscale.interfaceName ];
    networking.networkmanager.insertNameservers = [ "100.100.100.100" ];
    # based on nixos/modules/services/networking/networkmanager.nix
    environment.etc."NetworkManager/dispatcher.d/02overridesearchdomain".source = pkgs.writeScript "02overridesearchdomain" ''
      #!/bin/sh
      PATH=${lib.makeBinPath [ pkgs.gnused pkgs.gnugrep pkgs.coreutils ]}
      tmp=$(mktemp)
      sed '/search /d' /etc/resolv.conf > $tmp
      grep 'search ' /etc/resolv.conf | \
        grep -vf ${sd config.sys.tailscale.tailnets} > $tmp.sd
      cat $tmp ${sd config.sys.tailscale.tailnets} $tmp.sd > /etc/resolv.conf
      rm -f $tmp $tmp.sd
    '';
  };
}
