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
    sys.sudo.bellPrompt = lib.mkOption {
      description = "Whether to ring the terminal bell at the sudo prompt.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkMerge [
    (lib.mkIf config.sys.sudo.disableTimeout {
      security.sudo.extraConfig = ''
        Defaults passwd_timeout=0
      '';
    })
    (lib.mkIf config.sys.sudo.bellPrompt {
      security.sudo.extraConfig = ''
        Defaults passprompt="[sudo] password for %p: "
      '';
    })
  ];
}
