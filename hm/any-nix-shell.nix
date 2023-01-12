{ config, lib, pkgs, ... }:

{
  options = {
    sys.any-nix-shell.enable = lib.mkOption {
      description = "Whether to enable any-nix-shell, which makes nix commands respect your current shell.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.any-nix-shell.enable {
    programs.fish.interactiveShellInit = ''
      ${pkgs.any-nix-shell} fish --info-right | source
    '';
  };
}
