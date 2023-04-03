{ config, lib, options, pkgs, ... }:

{
  options = {
    sys.ssh.hosts = lib.mkOption {
      description = "Per-host SSH settings.";
      type = options.programs.ssh.matchBlocks.type;
      default = {};
    };
  };
  config = {
    # This only generates ~/.ssh/config, so there's little point in allowing it to be disabled.
    programs.ssh = {
      enable = true;
      matchBlocks = config.sys.ssh.hosts;
      extraConfig = ''
        AddKeysToAgent yes
      '';
    };
  };
}
