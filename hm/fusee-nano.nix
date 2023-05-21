{ config, lib, pkgs, ... }:

{
  options = {
    sys.fusee-nano.enable = lib.mkOption {
      description = "Whether to install fusee-nano, a Fusée Gelée exploit tool.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.fusee-nano.enable {
    home.packages = [ pkgs.fusee-nano ];
  };
}
