{ config, lib, ... }:

{
  imports = [
    (lib.mkRenamedOptionModule [ "sys" "disableSudoTimeout" ] [ "sys" "sudo" "disableTimeout" ])
  ];
  options = {
    sys.sudo.disableTimeout = lib.mkOption {
      description = "Whether to disable the sudo password prompt timeout.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.sudo.disableTimeout {
    security.sudo.extraConfig = ''
      Defaults passwd_timeout=0
    '';
  };
}
