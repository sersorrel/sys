{ config, lib, pkgs, ... }:

{
  options = {
    sys.calibre.enable = lib.mkOption {
      description = "Whether to install Calibre, an e-book management application.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.calibre.enable {
    home.packages = [ pkgs.calibre ];
  };
}
