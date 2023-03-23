{ config, lib, pkgs, ... }:

{
  options = {
    sys.exa.enable = lib.mkOption {
      description = "Whether to install exa, an ls replacement.";
      type = lib.types.bool;
      default = true; # TODO: once nothing implicitly depends on exa, disable this by default
    };
  };
  config = lib.mkIf config.sys.exa.enable {
    home.packages = [ pkgs.exa ];
    home.sessionVariables.EXA_COLORS = lib.concatStringsSep ":" (lib.mapAttrsToList (name: value: "${name}=${value}") {
      core = "1;31"; # bold red
    });
  };
}
