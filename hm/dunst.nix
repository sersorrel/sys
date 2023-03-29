{ config, lib, pkgs, ... }:

{
  options = {
    sys.dunst.enable = lib.mkOption {
      description = "Whether to enable dunst, a notification daemon.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.dunst.enable {
    services.dunst = {
      enable = true;
      iconTheme = {
        name = "Paper";
        package = pkgs.paper-icon-theme;
      };
      settings = {
        global = {
          monitor = 0;
          follow = "none";
          width = 300;
          offset = "30x30";
          notification_limit = 5;
          padding = 16;
          horizontal_padding = 16;
          frame_color = "#aaaaaa";
          separator_color = "frame";
          frame_width = 0;
          idle_threshold = 600;
          font = "Source Sans Variable";
          markup = "full";
          format = "%a: <b>%s</b>\\n%b";
          show_age_threshold = 60;
          word_wrap = true;
          icon_position = "left";
          max_icon_size = 24;
          corner_radius = 4;
          dmenu = "/run/current-system/sw/bin/rofi -dmenu -p ''";
          browser = "/run/current-system/sw/bin/google-chrome-stable";
          mouse_left_click = "do_action";
          mouse_middle_click = "close_current";
          mouse_right_click = "close_current";
        };
        urgency_low = {
          background = "#ffffff";
          foreground = "#000000";
          highlight = "#ec008c";
          timeout = 7;
        };
        urgency_normal = {
          background = "#ffffff";
          foreground = "#000000";
          highlight = "#ec008c";
          timeout = 7;
        };
        urgency_critical = {
          background = "#ffffff";
          foreground = "#000000";
          highlight = "#ec008c";
          timeout = 0;
        };
      };
    };
  };
}
