{ config, lib, pkgs, ... }:

{
  options = {
    sys.fragments.enable = lib.mkOption {
      description = "Whether to install Fragments, a BitTorrent client.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.fragments.enable {
    home.packages = [ pkgs.fragments ];
  };
}
