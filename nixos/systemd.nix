{
  # it is incomprehensible that StatusUnitFormat=combined is not the default
  boot.initrd.systemd.extraConfig = ''
    StatusUnitFormat=combined
  '';
}
