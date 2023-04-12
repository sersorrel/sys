{ config, lib, pkgs, ... }:

{
  options = {
    sys.launchpad = {
      autoPowerManagement = lib.mkOption {
        description = "Whether to automatically power any attached Launchpad Mini MK3 on and off on power-up/-down.";
        type = lib.types.bool;
        default = false;
      };
    };
  };
  config = {
    services.udev.extraRules = ''
      SUBSYSTEM=="sound", ENV{ID_MODEL}=="Launchpad_Mini_MK3", ENV{SYSTEMD_WANTS}+="launchpad.service", ENV{SYSTEMD_USER_WANTS}+="launchpad-daemon.service"
    '';
    systemd.services.launchpad = {
      description = "Novation Launchpad plugged status (not a real service)";
      unitConfig = {
        StopWhenUnneeded = true;
      };
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.coreutils}/bin/true";
        RemainAfterExit = true;
      };
    };
    powerManagement = lib.mkIf config.sys.launchpad.autoPowerManagement {
      powerDownCommands = ''
        launchpad_port=$(${pkgs.alsa-utils}/bin/amidi -l | ${pkgs.gawk}/bin/awk '/Launchpad Mini MK3 LPMiniMK3 MI/ { print $2 }')
        test -n "$launchpad_port" && ${pkgs.alsa-utils}/bin/amidi -p "$launchpad_port" -S "F000 20 29 02 0D 09 00 F7"
      '';
      powerUpCommands = ''
        launchpad_port=$(${pkgs.alsa-utils}/bin/amidi -l | ${pkgs.gawk}/bin/awk '/Launchpad Mini MK3 LPMiniMK3 MI/ { print $2 }')
        test -n "$launchpad_port" && ${pkgs.alsa-utils}/bin/amidi -p "$launchpad_port" -S "F000 20 29 02 0D 09 01 F7"
      '';
    };
  };
}
