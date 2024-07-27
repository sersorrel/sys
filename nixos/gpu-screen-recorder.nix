{ config, lib, pkgs, ... }:

{
  options = {
    sys.gpu-screen-recorder.enable = lib.mkOption {
      description = "Whether to enable gpu-screen-recorder, a hardware-accelerated replay capturing application.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.gpu-screen-recorder.enable {
    programs.gpu-screen-recorder.enable = true;
    environment.systemPackages = [ pkgs.gpu-screen-recorder-gtk ];
  };
}
