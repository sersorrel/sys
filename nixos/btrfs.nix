{ config, lib, ... }:

{
  options = {
    sys.btrfs.autoAutoScrub = lib.mkOption {
      description = "Whether to automatically schedule btrfs scrubs iff btrfs filesystems are configured.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.btrfs.autoAutoScrub {
    services.btrfs.autoScrub.enable = builtins.any (fsType: fsType == "btrfs") (lib.catAttrs "fsType" (lib.attrValues config.fileSystems));
  };
}
