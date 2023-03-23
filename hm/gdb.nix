{ config, lib, pkgs, ... }:

{
  options = {
    sys.gdb.enable = lib.mkOption {
      description = "Whether to install gdb.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.gdb.enable {
    home.packages = [ pkgs.gdb ];
    xdg.configFile."gdb/gdbearlyinit".text = ''
      set startup-quietly on
    '';
    xdg.configFile."gdb/gdbinit".text = ''
      set print thread-events off
      set pagination off
      set non-stop on
      set disassembly-flavor intel
    '';
  };
}
