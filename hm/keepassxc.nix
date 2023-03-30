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
    programs.i3.extraConfig = [ ''assign [class="^KeePassXC$" title="^(?!Auto-Type - KeePassXC$)"] workspace number 4'' ];
  };
}
