{ config, lib, ... }:

{
  options = {
    sys.keychain.enable = lib.mkOption {
      description = "Whether to enable keychain, an ssh-agent frontend.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.keychain.enable {
    programs.keychain = {
      enable = true;
      agents = [ "ssh" ];
      keys = [ "id_ed25519" ];
      extraFlags = [ "--noask" "--quiet" ];
    };
  };
}
