{ config, lib, pkgs, ... }:

{
  options = {
    sys.joystickwake.enable = lib.mkOption {
      description = "Whether to enable joystickwake, a daemon to keep the screen awake when using a game controller.";
      type = lib.types.bool;
      default = pkgs.stdenv.isLinux;
    };
  };
  config = lib.mkIf config.sys.joystickwake.enable {
    home.packages = [ pkgs.joystickwake ];
    # TODO: consider writing a systemd service rather than relying on the provided autostart file
  };
}
