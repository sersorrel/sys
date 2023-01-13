{ config, lib, pkgs, ... }:

{
  options = {
    sys.comma.enable = lib.mkOption {
      description = "Whether to install comma, which helps you run software without installing it.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.comma.enable {
    home.packages = [ pkgs.comma ];
  };
}
