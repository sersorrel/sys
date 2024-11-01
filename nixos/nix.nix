{ config, inputs, lib, pkgs, sysDir, unstable, ... }:

let
  channelPaths = let
    base = "/etc/nixpkgs/channels";
  in {
    nixpkgs = "${base}/nixpkgs";
    nixpkgs-unstable = "${base}/nixpkgs-unstable";
  };
  inherit (lib.strings) escapeNixString;
in
{
  options = {
    sys.lix.enable = lib.mkOption {
      description = "Whether to enable Lix-specific settings.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = {
    nix = {
      settings.experimental-features = [ "nix-command" "flakes" ] ++ lib.optional config.sys.lix.enable "repl-flake";
      settings.keep-outputs = true;
      settings.connect-timeout = 10;
      settings.log-lines = 20;
      registry = {
        nixpkgs.flake = inputs.nixpkgs;
        nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
      };
      nixPath = lib.mapAttrsToList (name: value: "${name}=${value}") channelPaths ++ [ "nixpkgs-overlays=${pkgs.runCommand "nixpkgs-overlays" {} ''
        # https://nixos.wiki/wiki/Overlays#Using_nixpkgs.overlays_from_configuration.nix_as_.3Cnixpkgs-overlays.3E_in_your_NIX_PATH
        mkdir -p $out
        cat > $out/overlays.nix <<EOF
        self: super:
        let
          inherit (super.lib) foldl' flip extends;
          overlays = (import ${sysDir + "/common/nixpkgs/overlays.nix"} {
            unstable = import ${escapeNixString (toString inputs.nixpkgs-unstable)} { system = ${escapeNixString pkgs.system}; config = import ${sysDir + "/common/nixpkgs/config.nix"}; };
            here = /. + ${escapeNixString (toString (sysDir + "/common/nixpkgs"))};
          });
        in foldl' (flip extends) (_: super) overlays self
        EOF
      ''}" ];
    };
    systemd.tmpfiles.rules = lib.mapAttrsToList (name: value: "L+ ${value} - - - - ${inputs.${name}}") channelPaths;
    systemd.services.nix-daemon.serviceConfig.Nice = 10;
    nixpkgs.config = import (sysDir + "/common/nixpkgs/config.nix");
    nixpkgs.overlays = import (sysDir + "/common/nixpkgs/overlays.nix") { inherit unstable; here = sysDir + "/common/nixpkgs"; };
  };
}
