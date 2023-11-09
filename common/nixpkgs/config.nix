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
    "webstorm"
    "zoom"
  ];
}
