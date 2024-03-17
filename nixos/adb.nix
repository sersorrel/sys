{ config, lib, ... }:

{
  options = {
    sys.adb.enable = lib.mkOption {
      description = "Whether to enable ADB, the Android Debug Bridge.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.adb.enable {
    programs.adb.enable = true;
    users.users.ash.extraGroups = [ "adbusers" ];
    environment.sessionVariables = {
      ADB_LIBUSB = "1";
    };
  };
}
