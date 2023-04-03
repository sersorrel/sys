{ config, lib, pkgs, ... }:

{
  options = {
    sys.wxhexeditor.enable = lib.mkOption {
      description = "Whether to install wxHexEditor, a hex editor.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.wxhexeditor.enable {
    home.packages = [ pkgs.wxhexeditor ];
  };
}
