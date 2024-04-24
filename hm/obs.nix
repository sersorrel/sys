{ config, lib, pkgs, ... }:

let
  ftl-config-file = "${config.xdg.configHome}/obs-studio/plugin_config/rtmp-services/services.json";
in
{
  options = {
    sys.obs.enable = lib.mkOption {
      description = "Whether to install OBS, the Open Broadcaster Software.";
      type = lib.types.bool;
      default = false;
    };
    sys.obs.ftl-servers = lib.mkOption {
      description = "FTL servers to enable streaming to.";
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
          };
          url = lib.mkOption {
            type = lib.types.str;
          };
        };
      });
      default = [];
    };
  };
  config = lib.mkIf config.sys.obs.enable {
    home.packages = [
      (pkgs.wrapOBS {
        plugins = [
          pkgs.obs-studio-plugins.obs-backgroundremoval
          pkgs.obs-studio-plugins.obs-pipewire-audio-capture
        ];
      })
    ];
    home.activation.obsFtl = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${pkgs.jq}/bin/jq '.services |= (map(select(.name != "FTL")) | . += [{"name": "FTL", "common": true, "protocol": "FTL", "servers": ${builtins.toJSON config.sys.obs.ftl-servers}, "recommended": {"keyint": 2,"output": "ftl_output", "bframes": 0}}])' ${ftl-config-file} | ${pkgs.moreutils}/bin/sponge ${ftl-config-file}
  '';
  };
}
