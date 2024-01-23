{ config, lib, pkgs, ... }:

{
  options = {
    sys.nix-tools.enable = lib.mkOption {
      description = "Whether to install various useful Nix-related tools.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.nix-tools.enable {
    home.packages = [
      pkgs.nix-diff
      pkgs.nix-output-monitor
      # pkgs.expect # for `unbuffer`ing nix-build when piping to nix-output-monitor
      # FIXME: having expect installed puts a broken mkpasswd in $PATH
      pkgs.nix-prefetch-github
      pkgs.nix-prefetch-scripts
    ];
  };
}
