{ config, ... }:

{
  programs.less.enable = true;
  programs.lesspipe.enable = true;
  home.sessionVariables = {
    LESS = "-iMR";
    LESSHISTFILE = "${config.xdg.cacheHome}/lesshst";
  };
}
