{ config, lib, pkgs, ... }:

{
  options = {
    sys.picard.enable = lib.mkOption {
      description = "Whether to install Picard, the official MusicBrainz audio tagger.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.picard.enable {
    home.packages = [ pkgs.picard ];
  };
}
