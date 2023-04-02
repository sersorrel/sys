{ config, lib, pkgs, ... }:

{
  options = {
    sys.dconf.enableEditor = lib.mkOption {
      description = "Whether to install dconf-editor, a graphical editor for dconf.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.dconf.enableEditor {
    home.packages = [ pkgs.gnome.dconf-editor ];
  };
}
