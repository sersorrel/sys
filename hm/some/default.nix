{ config, lib, pkgs, ... }:

{
  options = {
    sys.some.enable = lib.mkOption {
      description = "Whether to enable some, a meta-pager.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.some.enable {
    home.packages = [ (pkgs.callPackage ./package.nix {}) ];
  };
}
