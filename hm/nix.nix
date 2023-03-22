{ config, inputs, pkgs, sysDir, unstable, ... }:

{
  # Don't pipe stuff like nix-store output (which is frequently a single line) through a pager.
  # NB: this doesn't actually use cat(1); nix checks specifically for the string "cat" and disables the pager in that case.
  home.sessionVariables.NIX_PAGER = "cat";

  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
  };

  nixpkgs.config = import (sysDir + "/common/nixpkgs/config.nix");
  xdg.configFile."nixpkgs/config.nix".source = sysDir + "/common/nixpkgs/config.nix";

  nixpkgs.overlays = import (sysDir + "/common/nixpkgs/overlays.nix") { inherit unstable; here = sysDir + "/common/nixpkgs"; };
  xdg.configFile."nixpkgs/overlays.nix".text = let
    inherit (pkgs.lib) hasPrefix removePrefix;
    inherit (pkgs.lib.strings) escapeNixString;
    raw = builtins.readFile (sysDir + "/common/nixpkgs/overlays.nix");
    prefix = "{ unstable, here }:\n";
    processed = assert hasPrefix prefix raw; removePrefix prefix raw;
  in ''
    # TODO: work out hot to get (applicable) overlays registered with this instance of nixpkgs-unstable
    let unstable = import ${escapeNixString (toString inputs.nixpkgs-unstable)} { system = ${escapeNixString pkgs.system}; config = import ${config.xdg.configFile."nixpkgs/config.nix".source}; }; here = /. + ${escapeNixString (toString (sysDir + "/common/nixpkgs"))}; in
    ${processed}
  '';
}
