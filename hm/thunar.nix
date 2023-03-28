{ config, lib, pkgs, ... }:

{
  options = {
    sys.thunar.enable = lib.mkOption {
      description = "Whether to enable Thunar, a lightweight file manager.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.thunar.enable {
    home.packages = [
      pkgs.xfce.xfconf
      (pkgs.xfce.thunar.override {
        thunarPlugins = [
          pkgs.xfce.thunar-archive-plugin
          pkgs.xfce.thunar-media-tags-plugin
        ];
      })
    ];
  };
}
