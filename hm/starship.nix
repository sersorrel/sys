{ config, lib, pkgs, ... }:

{
  options = {
    sys.starship.enable = lib.mkOption {
      description = "Whether to enable Starship, a customizable shell prompt.";
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.sys.starship.enable {
    home.sessionVariables.STARSHIP_LOG = "error"; # hide warnings
    programs.fish.shellInit = ''
      eval (${config.home.profileDirectory}/bin/starship init fish)
    '';
    programs.starship = {
      enable = true;
      enableFishIntegration = false;
      settings = {
        battery = {
          disabled = true;
        };
        character = {
          success_symbol = ''[\$](bold green)'';
          error_symbol = ''[\$](bold red)'';
          vicmd_symbol = ''[:](bold green)'';
        };
        custom.jj = lib.mkIf config.sys.jj.enable {
          description = "Jujutsu commit details";
          format = "($output\n)";
          command = '' jj log --color always --no-graph -r '@|bookmarks(exact:"wip")' -T 'concat(separate(" ", label("bookmark", if(current_working_copy, "@")), label("bookmark", if(bookmarks, bookmarks.filter(|b| b.name() != "wip"))), format_short_change_id_with_hidden_and_divergent_info(self), if(empty, label("empty", "(empty)")), if(description, label("description", description.first_line()), label(if(empty, "empty"), description_placeholder))), "\n")' '';
          when = "jj --ignore-working-copy root";
          shell = "sh";
        };
        custom.just = {
          description = "Whether a justfile is present";
          format = "just [($output) ]($style)";
          command = '' just --list --list-heading "" --quiet | wc -l '';
          when = "test -e justfile || test -e Justfile";
          shell = "sh";
        };
        # TODO: this maybe causes some problems?
        #     INFO Failed accepting a client connection, accept_error: Accept(Os { code: 24, kind: Uncategorized, message: "Too many open files" })
        # Might be unrelated, though: https://github.com/nix-community/lorri/issues/82
        custom.lorri = {
          description = "Whether lorri has finished evaluation yet";
          symbol = "🚛";
          format = "with [$symbol($output) ]($style)";
          command = '' timeout 1 lorri internal stream-events --kind snapshot | ${pkgs.jq}/bin/jq -r --arg pwd "$PWD" 'if .[keys[0]].nix_file | startswith($pwd + "/") then {Completed: "", Started: "⌛", Failure: "❌"}[keys[0]] else "" end' '';
          when = "test -v IN_LORRI_SHELL";
          shell = "sh";
        };
        directory = {
          truncation_length = 7;
          truncate_to_repo = false;
          truncation_symbol = "…/";
          read_only = " 🔒";
          read_only_style = "";
          format = "in [$path]($style)[$read_only]($read_only_style) ";
        };
        gcloud = {
          format = "on [$symbol$account]($style) ";
        };
        git_branch = {
          only_attached = true;
        };
        git_commit = {
          only_detached = false;
          tag_disabled = false;
        };
        git_status = {
          untracked = "!";
          modified = "~";
          conflicted = "|||";
          ahead = ">";
          behind = "<";
          diverged = "<>";
        };
        hostname = {
          format = "on [$hostname]($style) ";
        };
        jobs = {
          threshold = 1;
          symbol = "✦ ";
        };
        shlvl = {
          disabled = false;
          symbol = "↕️ ";
          threshold = 3;
        };
        status = {
          disabled = false;
          symbol = "";
        };
        time = {
          disabled = false;
          format = "now [$time]($style) ";
        };
        username = {
          format = "[$user]($style) ";
        };
        format = let
          esc = builtins.fromJSON ''"\u001B"'';
        in lib.concatStrings [
          "🦉 "
          "$all" # automatically excludes modules we position explicitly
          ''${esc}\[48;2;242;229;188m${esc}\[K${esc}\[49m$line_break'' # TODO: make this look nicer on dark backgrounds
          "\${custom.jj}"
          "$jobs"
          "$battery"
          "$status"
          "$shell"
          "$character"
        ];
      };
    };
  };
}
