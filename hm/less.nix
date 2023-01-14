{ config, ... }:

{
  home.sessionVariables = {
    LESS = "iMR";
    LESSHISTFILE = "${config.xdg.cacheHome}/lesshst";
  };
}
