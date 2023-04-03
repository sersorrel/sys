{ config, lib, pkgs, ... }:

{
  options = {
    sys.tenacity.enable = lib.mkOption {
      description = "Whether to install Tenacity, an audio editor.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.tenacity.enable {
    home.packages = [ pkgs.tenacity ];
  };
}
