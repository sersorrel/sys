{ config, lib, pkgs, ... }:

{
  options = {
    sys.glimmer.enable = lib.mkOption {
      description = "Whether to install Glimmer, an image editor.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.glimmer.enable {
    home.packages = [
      (pkgs.callPackage ./glimmer.nix {
        autoreconfHook = pkgs.buildPackages.autoreconfHook269;
        lcms = pkgs.lcms2;
        inherit (pkgs.darwin.apple_sdk.frameworks) AppKit Cocoa;
      })
    ];
  };
}
