{
  description = "dependency flake for my system configurations";

  inputs = {

    nixpkgs.url = "nixpkgs";

  };

  outputs = inputs: {

    darwinModules.default = { ... }: {

    };

    homeModules.default = { ... }: {
      programs.home-manager.enable = true;
      home.enableNixpkgsReleaseCheck = true;
    };

    nixosModules.default = { ... }: {
      imports = [
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
