{ config, lib, pkgs, ... }:

{
  options = {
    sys.obsidian.enable = lib.mkOption {
      description = "Whether to install Obsidian, a personal knowledge base.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.obsidian.enable {
    home.packages = [ pkgs.obsidian ];
  };
}
