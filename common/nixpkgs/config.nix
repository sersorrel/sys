{ pkgs, ... }:

{
  allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "android-sdk-tools"
    "android-studio-stable"
    "clion"
    "dataspell"
    "discord"
    "discord-ptb"
    "ffmpeg-full"
    "google-chrome"
    "obsidian"
    "rider"
    "rust-rover"
    "slack"
    "steam"
    "steam-original"
    "steam-run"
    "sublime-merge"
    "talon"
    "talon-beta"
    "todoist-electron"
    "todoist-electron-8.9.3" # https://github.com/NixOS/nixpkgs/issues/267508
    "webstorm"
    "zoom"
  ];
}
