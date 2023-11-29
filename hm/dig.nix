{ config, lib, pkgs, ... }:

{
  options = {
    sys.dig.enable = lib.mkOption {
      description = "Whether to install dig, a command-line DNS lookup utility.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = {
    home.packages = [ pkgs.dig.dnsutils ];
    home.file.".digrc".text = ''
      +noall +answer +ttlunits +multiline +search
    '';
  };
}
