{ config, lib, pkgs, ... }:

{
  options = {
    sys.jj.enable = lib.mkOption {
      description = "Whether to install Jujutsu, a version control system.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.jj.enable {
    programs.jujutsu = {
      enable = true;
      settings = {
        aliases = {
          aa = [ "log" "-r" "all()" ];
          update = [ "git" "fetch" "--all-remotes" ];
        };
        core = {
          fsmonitor = "watchman";
        };
        git = {
          private-commits = "description(glob:'wip:*') | description(glob:'private:*')";
        };
        templates = {
          draft_commit_description = ''
            concat(
            description,
            if(!description, "\n"),
            "\n",
            surround(
            "\nJJ: This commit contains the following changes:\n", "",
            indent("JJ:     ", diff.summary()),
            ),
            "JJ:\n",
            "JJ: ignore-rest\n",
            diff.git(),
            )
          '';
        };
        user = {
          name = config.sys.git.name;
          email = config.sys.git.email;
        };
        ui = {
          default-command = "log";
          pager = "some";
        };
      };
    };
  };
}
