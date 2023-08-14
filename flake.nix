{
  description = "dependency flake for my system configurations";

  inputs = {

  };

  # TODO: remove this once todoist-electron is updated
  nixConfig = {
    permittedInsecurePackages = [
      "electron-21.4.0"
    ];
  };

  outputs = inputs: {

    darwinModules.default = { ... }: {
      imports = inputs.self.lib.importDir ./darwin;
      _module.args.sysDir = ./.;
    };

    homeModules.default = { lib, ... }: {
      _module.args.sysDir = ./.;
      imports = inputs.self.lib.importDir ./hm;
      programs.home-manager.enable = true;
      home.enableNixpkgsReleaseCheck = true;
    };

    nixosModules.default = { lib, ... }: {
      _module.args.sysDir = ./.;
      imports = inputs.self.lib.importDir ./nixos;
      boot.loader.grub.configurationLimit = 30;
      boot.loader.systemd-boot.configurationLimit = 30;
      boot.tmp.cleanOnBoot = true;
      environment.shellAliases = {
        l = null;
        ll = null;
        ls = null;
      };
      systemd.network.wait-online.anyInterface = true;
      users.mutableUsers = false;
    };

    lib = let
      inherit (builtins) attrNames concatMap stringLength substring;
      concatMapAttrsToList = f: attrs: concatMap (name: f name attrs.${name}) (attrNames attrs); # see lib.mapAttrsToList
      hasPrefix = prefix: s: substring 0 (stringLength prefix) s == prefix; # from nixpkgs
      hasSuffix = suffix: s: let
        length = stringLength s;
        suffixLength = stringLength suffix;
      in length >= suffixLength && substring (length - suffixLength) length s == suffix; # from nixpkgs
    in {
      importDir = dir: concatMapAttrsToList (name: value: if (value == "regular" && hasSuffix ".nix" name) || (value == "directory" && !hasPrefix "." name) then [(dir + "/${name}")] else []) (builtins.readDir dir);
    };

  };
}
