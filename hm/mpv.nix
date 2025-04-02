{ config, lib, pkgs, ... }:

{
  options = {
    sys.mpv.enable = lib.mkOption {
      description = "Whether to install mpv, a media player.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.mpv.enable {
    programs.mpv = {
      enable = true;
      package = (pkgs.mpv-unwrapped.wrapper {
        mpv = pkgs.mpv-unwrapped.override {
          ffmpeg = pkgs.ffmpeg-full; # TODO: check config.sys.ffmpeg-full.enable and/or use the same package as that
        };
      }).override {
        scripts = [
          pkgs.mpvScripts.mpris
          ((pkgs.writeTextFile {
            name = "mpv-audio-osc";
            executable = true;
            destination = "/share/mpv/scripts/audio-osc.lua";
            text = ''
              function ends_with(value, suffix)
                return suffix == "" or value:sub(-#suffix) == suffix
              end
              -- https://github.com/mpv-player/mpv/issues/3500#issuecomment-305646994
              mp.register_event("file-loaded", function()
                local hasvid = mp.get_property_osd("video") ~= "no"
                -- that's not accurate if there's embedded album art, so we also test the filename
                local path = mp.get_property("path")
                hasvid = hasvid and not ends_with(path, ".flac")
                hasvid = hasvid and not ends_with(path, ".mp3")
                mp.commandv("script-message", "osc-visibility", (hasvid and "auto" or "always"), "no-osd")
                mp.commandv("set", "options/osd-bar", (hasvid and "yes" or "no"))
              end)
            '';
          }).overrideAttrs (old: {
            passthru.scriptName = "audio-osc.lua"; # TODO FIXME: this probably overrides any existing passthru...
          }))
          pkgs.mpvScripts.thumbfast
          ((pkgs.mpvScripts.buildLua {
            pname = "mpv-thumbfast-vanilla-osc";
            version = "0-unstable-2023-12-21";
            src = pkgs.fetchFromGitHub {
              owner = "po5";
              repo = "thumbfast";
              rev = "9d78edc167553ccea6290832982d0bc15838b4ac"; # vanilla-osc branch
              hash = "sha256-AG3w5B8lBcSXV4cbvX3nQ9hri/895xDbTsdaqF+RL64=";
            };
            passthru.scriptName = "player/lua/osc.lua";
          }).overrideAttrs (old: {
            passthru.scriptName = "osc.lua"; # TODO FIXME: this probably overrides any existing passthru...
          }))
        ];
        # TODO: mute on step forwards: https://github.com/mpv-player/mpv/issues/6104
      };
      defaultProfiles = [ "gpu-hq" ];
      config = {
        keep-open = true;
        osd-on-seek = false;
        osd-msg3 = "\${osd-sym-cc} \${time-pos} / \${duration} (\${percent-pos}%), \${time-remaining} left";
        screenshot-format = "png";
        screenshot-directory = builtins.replaceStrings ["$HOME"] ["${config.home.homeDirectory}"] "${config.xdg.userDirs.pictures}/Screenshots/mpv";
        screenshot-template = "%tF %tT %F %P %#n";
        replaygain = "track";
      };
      bindings = {
        HOME = "seek 0 absolute+exact";
        END = "seek 100 absolute-percent+exact";
        UP = "ignore";
        DOWN = "ignore";
      };
    };
  };
}
