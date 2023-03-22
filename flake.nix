{
  description = "dependency flake for my system configurations";

  inputs = {

  };

  outputs = inputs: {

    darwinModules.default = { ... }: {
      _module.args.sysDir = ./.;
    };

    homeModules.default = { ... }: {
      _module.args.sysDir = ./.;
      imports = [
        ./hm/any-nix-shell.nix
        ./hm/bat.nix
        ./hm/comma.nix
        ./hm/dircolors.nix
        ./hm/direnv.nix
        ./hm/exa.nix
        ./hm/fd.nix
        ./hm/fish.nix
        ./hm/fzf.nix
        ./hm/git-fast-forward-all
        ./hm/git.nix
        ./hm/less.nix
        ./hm/nix.nix
        ./hm/ripgrep.nix
        ./hm/starship.nix
        ./hm/neovim
      ];
      programs.home-manager.enable = true;
      home.enableNixpkgsReleaseCheck = true;
    };

    nixosModules.default = { ... }: {
      _module.args.sysDir = ./.;
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
