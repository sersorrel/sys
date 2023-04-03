{ config, lib, pkgs, ... }:

{
  options = {
    sys.lorri.enable = lib.mkOption {
      description = "Whether to install lorri, a nix-shell replacement.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.lorri.enable {
    services.lorri.enable = true;
  };
}
