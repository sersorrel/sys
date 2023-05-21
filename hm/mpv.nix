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
      package = pkgs.wrapMpv (pkgs.mpv-unwrapped.override {
        ffmpeg_5 = pkgs.ffmpeg_5-full; # TODO: check config.sys.ffmpeg-full.enable and/or use the same package as that
      }) {
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
            passthru.scriptName = "audio-osc.lua";
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
