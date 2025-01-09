{ inputs, sysDir, unstable, ... }:

{
  # TODO: nix.settings, nix.registry, etc.
  nixpkgs.config = import (sysDir + "/common/nixpkgs/config.nix");
  nixpkgs.overlays = import (sysDir + "/common/nixpkgs/overlays.nix") { inherit unstable; here = sysDir + "/common/nixpkgs"; inherit (inputs) moonlight; };
}
