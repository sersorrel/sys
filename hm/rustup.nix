{ config, lib, pkgs, ... }:

{
  options = {
    sys.rustup.enable = lib.mkOption {
      description = "Whether to install rustup, the Rust toolchain installer.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.rustup.enable {
    home.packages = [ pkgs.rustup ];
  };
}
