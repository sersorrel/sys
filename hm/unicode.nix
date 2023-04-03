{ config, lib, pkgs, ... }:

{
  options = {
    sys.unicode.enable = lib.mkOption {
      description = "Whether to install the unicode CLI program.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.unicode.enable {
    home.packages = [ pkgs.unicode-paracode ];
  };
}
