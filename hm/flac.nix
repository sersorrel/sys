{ config, lib, pkgs, ... }:

{
  options = {
    sys.flac.enable = lib.mkOption {
      description = "Whether to install flac, a command-line FLAC encoder/decoder.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.flac.enable {
    home.packages = [ pkgs.flac ];
  };
}
