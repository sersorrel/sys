{ config, lib, pkgs, ... }:

{
  options = {
    sys.kid3.enable = lib.mkOption {
      description = "Whether to install Kid3, a music tagger.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.kid3.enable {
    home.packages = [ pkgs.kid3 ];
  };
}
