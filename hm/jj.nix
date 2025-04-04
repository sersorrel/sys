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
    home.packages = [ pkgs.watchman ];
    programs.jujutsu = {
      enable = true;
      settings = {
        aliases = {
          aa = [ "log" "-r" "all()" ];
          blt = [ "b" "l" "-t" ];
          tug = ["bookmark" "move" "--from" "heads(::@- & bookmarks())" "--to" "@-"];
          unwip = [ "util" "exec" "--" "bash" "-c" ''
            jj log --no-graph -r "''${1:-@}" -T description | sed -e 's/^wip: //' | jj desc --stdin "''${1:-@}"
          '' "bash" ];
          update = [ "git" "fetch" "--all-remotes" ];
          wip = [ "bookmark" "set" "--allow-backwards" "wip" "--revision" ];
          wop = [ "bookmark" "forget" "wip" ];
        };
        core = {
          fsmonitor = "watchman";
        };
        git = {
          private-commits = "description(glob:'wip:*') | description(glob:'private:*')";
        };
        revset-aliases = {
          h = "@+";
          i = "@";
          j = "@-";
        };
        templates = {
          draft_commit_description = ''
            concat(
              description,
              if(!description, "\n"),
              "\n",
              surround(
                "JJ: This commit contains the following changes:\n", "",
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
    xdg.configFile."fish/completions/jj.fish".text = lib.mkIf config.sys.fish.enable ''
      COMPLETE=fish jj | source
    '';
  };
}
