{ config, lib, pkgs, ... }:

{
  options = {
    sys.wine.enable = lib.mkOption {
      description = "Whether to install Wine, a Windows compatibility layer.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.wine.enable {
    home.packages = [
      pkgs.wineWowPackages.unstableFull
      pkgs.winetricks
    ];
  };
}
