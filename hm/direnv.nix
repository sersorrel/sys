{ config, lib, ... }:

{
  options = {
    sys.direnv.enable = lib.mkOption {
      description = "Whether to enable direnv, a per-directory environment variable loader.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.direnv.enable {
    programs.direnv.enable = true;
  };
}
