{ pkgs, ... }:

{
  home.packages = [ (pkgs.callPackage ./git-fast-forward-all-branches.nix {}) ];
}
