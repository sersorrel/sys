{ config, lib, ... }:

{
  options = {
    sys.disableSudoTimeout = lib.mkOption {
      description = "Whether to disable the sudo password prompt timeout.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.disableSudoTimeout {
    security.sudo.extraConfig = ''
      Defaults passwd_timeout=0
    '';
  };
}
