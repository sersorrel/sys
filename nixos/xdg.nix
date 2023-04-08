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
    environment.systemPackages = [
      pkgs.glib
      (pkgs.runCommandLocal "gnome-terminal" {} ''
        mkdir -p $out/bin
        ln -s ${pkgs.kitty}/bin/kitty $out/bin/gnome-terminal
      '')
    ];
  };
}
