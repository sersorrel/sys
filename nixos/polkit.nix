{ config, lib, pkgs, ... }:

{
  options = {
    sys.polkit.enable = lib.mkOption {
      description = "Whether to enable polkit, a privilege management daemon.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.polkit.enable {
    security.polkit.enable = true;
    systemd.user.services.polkit-gnome = {
      description = "polkit_gnome authentication agent";
      wantedBy = [ "graphical-session.target" ];
      requires = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
