{ config, inputs, pkgs, sysDir, unstable, ... }:

{
  # Don't show stuff like nix-store output (which is frequently a single line) in less.
  home.sessionVariables.NIX_PAGER = "some";

  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
  };

  nixpkgs.config = import (sysDir + "/common/nixpkgs/config.nix");
  xdg.configFile."nixpkgs/config.nix".source = sysDir + "/common/nixpkgs/config.nix";

  nixpkgs.overlays = import (sysDir + "/common/nixpkgs/overlays.nix") { inherit unstable; here = sysDir + "/common/nixpkgs"; moonlight = inputs.moonlight or null; };
  xdg.configFile."nixpkgs/overlays.nix".text = let
    inherit (pkgs.lib) hasPrefix removePrefix;
    inherit (pkgs.lib.strings) escapeNixString;
    raw = builtins.readFile (sysDir + "/common/nixpkgs/overlays.nix");
    prefix = "{ unstable, here, moonlight }:\n";
    processed = assert hasPrefix prefix raw; removePrefix prefix raw;
  in ''
    # TODO: work out how to get (applicable) overlays registered with this instance of nixpkgs-unstable
    let unstable = import ${escapeNixString (toString inputs.nixpkgs-unstable)} { system = ${escapeNixString pkgs.system}; config = import ${config.xdg.configFile."nixpkgs/config.nix".source}; }; here = /. + ${escapeNixString (toString (sysDir + "/common/nixpkgs"))}; moonlight = ${if inputs ? moonlight then "builtins.getFlake (${escapeNixString (toString inputs.moonlight)})" else "null"}; in
    ${processed}
  '';
}
