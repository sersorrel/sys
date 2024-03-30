{ config, lib, pkgs, ... }:

let
  unified-inhibit = pkgs.callPackage ./package.nix {};
in
{
  options = {
    sys.unified-inhibit.enable = lib.mkOption {
      description = "Whether to enable unified-inhibit, a bridge between sleep inhibit protocols.";
      type = lib.types.bool;
      default = pkgs.stdenv.isLinux;
    };
  };
  config = lib.mkIf config.sys.unified-inhibit.enable {
    systemd.user.services.unified-inhibit = {
      Unit = {
        Description = "unified-inhibit wakelock bridge";
        Requires = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${unified-inhibit}/bin/uinhibitd";
      };
    };
  };
}
