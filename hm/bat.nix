{ config, lib, ... }:

{
  options = {
    sys.bat.enable = lib.mkOption {
      description = "Whether to install bat, a command-line syntax highlighter.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.bat.enable {
    programs.bat = {
      enable = true;
      config = {
        italic-text = "always";
        style = "numbers,changes";
        theme = "gruvbox-light";
      };
    };
  };
}
