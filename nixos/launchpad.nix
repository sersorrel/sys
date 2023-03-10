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
  config = lib.mkIf config.sys.launchpad.autoPowerManagement {
    powerManagement = {
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
