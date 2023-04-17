{ config, lib, pkgs, ... }:

{
  options = {
    sys.keepassxc.enable = lib.mkOption {
      description = "Whether to install KeePassXC, a password manager.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.keepassxc.enable {
    home.packages = [ pkgs.keepassxc ];
  };
}
