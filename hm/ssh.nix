{
  # This only generates ~/.ssh/config, so there's little point in allowing it to be disabled.
  programs.ssh = {
    enable = true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
}
