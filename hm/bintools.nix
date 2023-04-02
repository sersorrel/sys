{ config, lib, pkgs, ... }:

{
  options = {
    sys.bintools.enable = lib.mkOption {
      description = "Whether to install bintools, which provides things like objdump and strings.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.bintools.enable {
    home.packages = [ pkgs.bintools ];
  };
}
