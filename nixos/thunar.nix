{ config, lib, pkgs, ... }:

{
  options = {
    sys.thunar.enable = lib.mkOption {
      description = "Whether to install Thunar, a lightweight file manager.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.thunar.enable {
    programs.thunar = {
      enable = true;
      plugins = [
        pkgs.xfce.thunar-archive-plugin
        pkgs.xfce.thunar-media-tags-plugin
      ];
    };
    environment.systemPackages = [
      pkgs.xfce.exo
    ];
  };
}
