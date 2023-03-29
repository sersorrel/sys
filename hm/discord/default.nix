{ config, lib, pkgs, ... }:

let
  krisp-patcher = pkgs.writers.writePython3Bin "krisp-patcher" {
    libraries = with pkgs.python3Packages; [ capstone pyelftools ];
    flakeIgnore = [
      "E501" # line too long (82 > 79 characters)
      "F403" # ‘from module import *’ used; unable to detect undefined names
      "F405" # name may be undefined, or defined from star imports: module
    ];
  } (builtins.readFile ./krisp-patcher.py);
in
{
  options = {
    sys.discord.enable = lib.mkOption {
      description = "Whether to install Discord, a voice and text chat platform.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.discord.enable {
    home.packages = [ pkgs.discord krisp-patcher ];
  };
}
