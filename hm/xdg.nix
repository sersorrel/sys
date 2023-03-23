{ config, lib, pkgs, ... }:

{
  options = {
    sys.xdg.enable = lib.mkOption {
      description = "Whether to manage XDG base directories.";
      type = lib.types.bool;
      default = pkgs.stdenv.isLinux;
    };
  };
  config = lib.mkIf config.sys.xdg.enable {
    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
      };
    };
  };
}
