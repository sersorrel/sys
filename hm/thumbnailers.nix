{ config, lib, pkgs, ... }:

{
  options = {
    sys.thumbnailers.enable = lib.mkOption {
      description = "Whether to enable custom thumbnailers.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.thumbnailers.enable {
    # https://moritzmolch.com/blog/1749.html, https://docs.xfce.org/xfce/tumbler/available_plugins
    # note: apparently xcftools is unmaintained since 2019 and nixpkgs' version has multiple code-execution vulnerabilities, so let's not use xcf2png
    xdg.dataFile."thumbnailers/xcf.thumbnailer".text = ''
      [Thumbnailer Entry]
      TryExec=${pkgs.imagemagick}/bin/convert
      Exec=${pkgs.imagemagick}/bin/convert xcf:%i -flatten -scale 512x%s png:%o
      MimeType=image/x-xcf;
    '';
  };
}
