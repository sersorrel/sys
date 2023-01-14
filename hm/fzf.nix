{ config, lib, ... }:

{
  options = {
    sys.fzf.enable = lib.mkOption {
      description = "Whether to install fzf, a command-line fuzzy finder.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.fzf.enable {
    programs.fzf.enable = true;
  };
}
