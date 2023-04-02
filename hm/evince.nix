{ config, lib, pkgs, ... }:

{
  options = {
    sys.evince.enable = lib.mkOption {
      description = "Whether to install Evince, a document viewer.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.evince.enable {
    home.packages = [ pkgs.evince ];
  };
}
