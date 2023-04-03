{ config, lib, pkgs, ... }:

{
  options = {
    sys.gpg.enable = lib.mkOption {
      description = "Whether to install GnuPG, a PGP implementation.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.gpg.enable {
    home.packages = [
      pkgs.gnupg
      pkgs.pinentry-gtk2
    ];
    home.file.".gnupg/gpg-agent.conf".text = ''
      pinentry-program ${pkgs.pinentry-gtk2}/bin/pinentry
    '';
  };
}
