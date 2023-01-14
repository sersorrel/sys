{ ... }:

{
  # Don't pipe stuff like nix-store output (which is frequently a single line) through a pager.
  # NB: this doesn't actually use cat(1); nix checks specifically for the string "cat" and disables the pager in that case.
  home.sessionVariables.NIX_PAGER = "cat";
}
