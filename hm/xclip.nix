{ config, lib, pkgs, ... }:

{
  options = {
    sys.xclip.enable = lib.mkOption {
      description = "Whether to install xclip, a CLI tool to interact with the clipboard.";
      type = lib.types.bool;
      default = pkgs.stdenv.isLinux;
    };
  };
  config = lib.mkIf config.sys.xclip.enable {
    home.packages = [ pkgs.xclip ];
  };
}
