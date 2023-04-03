{
  programs.readline = {
    enable = true;
    bindings = {
      "\\C-w" = "backward-kill-word";
    };
    variables = {
      colored-stats = true; # show file type by colour
      visible-stats = true; # show file type by trailing character
      colored-completion-prefix = true; # colour any common completion prefix differently
      completion-prefix-display-length = 10; # cap the length of the displayed common prefix
      show-all-if-ambiguous = true; # show all completions immediately if ambiguous
      menu-complete-display-prefix = true; # complete as far as possible first, though
      bind-tty-special-chars = false; # so we can use a more useful definition of "word" for ^W
      completion-ignore-case = true;
      enable-bracketed-paste = true;
      keyseq-timeout = 200; # reduce the delay between pressing escape and exiting i-search
    };
  };
}
