{ config, lib, pkgs, ... }:

{
  options = {
    sys.gnome-music.enable = lib.mkOption {
      description = "Whether to install GNOME Music.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.gnome-music.enable {
    home.packages = [ pkgs.gnome-music ];
  };
}
