{ config, lib, pkgs, ... }:

{
  options = {
    sys.signal.enable = lib.mkOption {
      description = "Whether to install Signal, a secure messaging client.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.signal.enable {
    home.packages = [ pkgs.signal-desktop-bin ];
  };
}
