{ config, lib, pkgs, ... }:

{
  options = {
    sys.eiciel.enable = lib.mkOption {
      description = "Whether to install Eiciel, a graphical ACL editor.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.eiciel.enable {
    home.packages = [ pkgs.eiciel ];
    programs.i3.extraConfig = [ ''for_window [class="^eiciel$"] floating enable'' ];
  };
}
