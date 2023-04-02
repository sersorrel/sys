{ config, lib, ... }:

{
  options = {
    sys.dconf.enable = lib.mkOption {
      description = "Whether to enable dconf, a configuration system.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.dconf.enable {
    programs.dconf.enable = true;
  };
}
