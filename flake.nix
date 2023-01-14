{
  description = "dependency flake for my system configurations";

  inputs = {

    nixpkgs.url = "nixpkgs";

  };

  outputs = inputs: {

    darwinModules.default = { ... }: {

    };

    homeModules.default = { ... }: {
      imports = [
        ./hm/any-nix-shell.nix
        ./hm/bat.nix
        ./hm/comma.nix
        ./hm/direnv.nix
        ./hm/exa.nix
        ./hm/fd.nix
        ./hm/fish.nix
        ./hm/fzf.nix
        ./hm/git.nix
        ./hm/less.nix
        ./hm/nix.nix
      ];
      programs.home-manager.enable = true;
      home.enableNixpkgsReleaseCheck = true;
    };

    nixosModules.default = { ... }: {
      imports = [
        ./nixos/launchpad.nix
        ./nixos/sudo-timeout.nix
      ];
      environment.shellAliases = {
        l = null;
        ll = null;
        ls = null;
      };
      users.mutableUsers = false;
    };

  };
}
