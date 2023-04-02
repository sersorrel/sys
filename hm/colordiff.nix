{ config, lib, pkgs, ... }:

{
  options = {
    sys.colordiff.enable = lib.mkOption {
      description = "Whether to install colordiff.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.colordiff.enable {
    home.packages = [ pkgs.colordiff ];
    xdg.configFile."colordiff/colordiffrc".text = ''
      banner=no
    '';
  };
}
