{
  description = "dependency flake for my system configurations";

  inputs = {

  };

  outputs = inputs: let
    mkLib = lib: rec {
      concatMapAttrsToList = f: attrs: builtins.concatMap (name: f name attrs.${name}) (lib.attrNames attrs); # see lib.mapAttrsToList
      mkImports = dir: concatMapAttrsToList (name: value: if (value == "regular" && lib.hasSuffix ".nix" name) || (value == "directory" && !lib.hasPrefix "." name) then [(dir + "/${name}")] else []) (builtins.readDir dir);
    };
  in {

    darwinModules.default = { ... }: {
      _module.args.sysDir = ./.;
    };

    homeModules.default = { lib, ... }: {
      _module.args.sysDir = ./.;
      imports = (mkLib lib).mkImports ./hm;
      programs.home-manager.enable = true;
      home.enableNixpkgsReleaseCheck = true;
    };

    nixosModules.default = { lib, ... }: {
      _module.args.sysDir = ./.;
      imports = (mkLib lib).mkImports ./nixos;
      environment.shellAliases = {
        l = null;
        ll = null;
        ls = null;
      };
      users.mutableUsers = false;
    };

  };
}
