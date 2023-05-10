{ config, lib, pkgs, ... }:

{
  options = {
    sys.libreoffice.enable = lib.mkOption {
      description = "Whether to install LibreOffice, a set of document editing software.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.libreoffice.enable {
    home.packages = [ pkgs.libreoffice ];
  };
}
