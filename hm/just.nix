{ config, lib, pkgs, ... }:

{
  options = {
    sys.just.enable = lib.mkOption {
      description = "Whether to install just, a command runner.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.just.enable {
    home.packages = [ pkgs.just ];
  };
}
