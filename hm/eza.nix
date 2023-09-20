{ config, lib, pkgs, ... }:

{
  options = {
    sys.eza.enable = lib.mkOption {
      description = "Whether to install eza, an ls replacement.";
      type = lib.types.bool;
      default = true; # TODO: once nothing implicitly depends on eza, disable this by default
    };
  };
  config = lib.mkIf config.sys.eza.enable {
    home.packages = [ pkgs.eza ];
    home.sessionVariables.EZA_COLORS = lib.concatStringsSep ":" (lib.mapAttrsToList (name: value: "${name}=${value}") {
      core = "1;31"; # bold red
    });
  };
}
