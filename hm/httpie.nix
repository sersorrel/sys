{ config, lib, pkgs, ... }:

{
  options = {
    sys.httpie.enable = lib.mkOption {
      description = "Whether to install HTTPie, a command-line HTTP client.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.httpie.enable {
    home.packages = [ pkgs.httpie ];
  };
}
