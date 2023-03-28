{
  # this creates things like ~/.profile, which are essential for nix to work properly
  # (otherwise options like home.sessionVariables will have no effect on graphical sessions)
  programs.bash = {
    enable = true;
    historyControl = [ "ignoredups" "ignorespace" ];
  };
}
