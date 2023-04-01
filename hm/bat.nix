{ config, lib, ... }:

{
  options = {
    sys.bat.enable = lib.mkOption {
      description = "Whether to install bat, a command-line syntax highlighter.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.bat.enable {
    programs.bat = {
      enable = true;
      config = {
        italic-text = "always";
        style = "plain";
        theme = "gruvbox-light";
      };
    };
  };
}
