{ config, lib, pkgs, ... }:

{
  options = {
    sys.gnome-keyring.enable = lib.mkOption {
      description = "Whether to enable GNOME Keyring, a Secret Service provider and SSH agent.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = {
    services.gnome.gnome-keyring.enable = true;
    environment.systemPackages = [ pkgs.seahorse ];
  };
}
