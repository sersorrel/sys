{ config, ... }:

{
  home.sessionVariables = {
    SYSTEMD_LESS = "SRM"; # i.e. not FXK
  } // (if config.sys.some.enable then {
    SYSTEMD_PAGER = "some";
    SYSTEMD_PAGERSECURE = "0";
  } else {});
}
