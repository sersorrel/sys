{ config, lib, pkgs, ... }:

{
  options = {
    sys.steam.enable = lib.mkOption {
      description = "Whether to install Steam, a games distribution platform.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.steam.enable {
    programs.steam.enable = true;
    hardware.steam-hardware.enable = true;
  };
}
