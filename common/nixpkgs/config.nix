{ pkgs, ... }:

{
  allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "clion"
    "discord"
    "discord-ptb"
    "ffmpeg-full"
    "google-chrome"
    "obsidian"
    "rider"
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
  permittedInsecurePackages = [
    (assert builtins.compareVersions pkgs.todoist-electron.version "1.1.2" == -1; "electron-21.4.0") # remember to remove this from flake.nix nixConfig too!
  ];
}
