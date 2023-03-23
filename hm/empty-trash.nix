{ config, lib, pkgs, ... }:

{
  options = {
    sys.empty-trash.enable = lib.mkOption {
      description = "Whether to periodically empty the trash.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.empty-trash.enable {
    systemd.user.timers = {
      empty-trash = {
        Unit = {
          Description = "Regularly delete old trashed files";
          PartOf = [ "empty-trash.service" ];
        };
        Timer = {
          OnStartupSec = 60 * 60; # 1 hour after login
          OnUnitActiveSec = 60 * 60 * 24; # every 24 hours thereafter
          AccuracySec = 60 * 60; # no need to run it *exactly* every 24 hours
        };
        Install = {
          WantedBy = [ "timers.target" ];
        };
      };
    };
    systemd.user.services = {
      empty-trash = {
        Unit = {
          Description = "Delete old trashed files";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.trash-cli}/bin/trash-empty 28"; # delete files more than 28 days old
        };
      };
    };
  };
}
