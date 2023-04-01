{ config, lib, pkgs, ... }:

{
  options = {
    sys.xdg.enable = lib.mkOption {
      description = "Whether to enable an XDG desktop portal.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.xdg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      xdgOpenUsePortal = true;
    };
  };
}
