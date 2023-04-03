{ config, lib, pkgs, ... }:

{
  options = {
    sys.lsof.enable = lib.mkOption {
      description = "Whether to install lsof, a program to examine open files.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.lsof.enable {
    home.packages = [ pkgs.lsof ];
  };
}
