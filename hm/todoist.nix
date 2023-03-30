{ config, lib, pkgs, ... }:

{
  options = {
    sys.todoist.enable = lib.mkOption {
      description = "Whether to install Todoist, a to-do list application.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.todoist.enable {
    home.packages = [ pkgs.todoist-electron ];
  };
}
