{ pkgs, ... }:

{
  fonts.fontconfig.enable = true; # let fontconfig see fonts installed by home-manager
  home.packages = with pkgs; [
    iosevka
    jost
    meslo-lgs-nf
    monaspace
    noto-fonts
    noto-fonts-cjk
    source-sans-pro
  ];
}
