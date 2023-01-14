{ config, lib, pkgs, ... }:

{
  options = {
    sys.ripgrep.enable = lib.mkOption {
      description = "Whether to install ripgrep, a grep replacement.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.ripgrep.enable {
    home.packages = [ pkgs.ripgrep ];
    home.sessionVariables.RIPGREP_CONFIG_PATH = "${config.xdg.configHome}/ripgrep/config";
    xdg.configFile."ripgrep/config".text = ''
      --smart-case
      --max-columns
      1000
      --max-columns-preview
      --multiline-dotall
      --ignore-file
      ${config.xdg.configHome}/ripgrep/ignore
      --type-add
      cfg:*.cfg
    '';
    xdg.configFile."ripgrep/ignore".text = ''
      Cargo.lock
      Gemfile.lock
      flake.lock
      package-lock.json
      poetry.lock
    '';
  };
}
