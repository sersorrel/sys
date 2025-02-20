{ config, lib, ... }:

{
  options = {
    sys.gh.enable = lib.mkOption {
      description = "Whether to install gh, the GitHub CLI interface.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.gh.enable {
    programs.gh = {
      enable = true;
      settings = {
        aliases = {
          fork = "repo fork --default-branch-only";
        };
        git_protocol = "ssh";
      };
    };
  };
}
