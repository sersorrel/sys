{ config, lib, pkgs, ... }:

{
  options = {
    sys.fd.enable = lib.mkOption {
      description = "Whether to install fd, a find replacement.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.fd.enable {
    home.packages = [ pkgs.fd ];
  };
}
