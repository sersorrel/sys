{ unstable, here }:

let
  localPath = path: let
    inherit (builtins) stringLength substring;
    # careful here, otherwise we accidentally start copying things to the store
    path' = toString path;
    this' = toString ./.;
    pathLen = stringLength path';
    thisLen = stringLength this';
  in assert substring 0 thisLen path' == this'; here + (substring thisLen pathLen path');
in
[
  (self: super: {
    # out-of-date software/waiting for backports
    obsidian-export = assert !(super ? obsidian-export); super.callPackage (localPath ./programs/obsidian-export.nix) {};
    unicode-paracode = assert builtins.compareVersions super.unicode-paracode.version "2.9" != 1; super.unicode-paracode.overrideAttrs (old: { # https://github.com/garabik/unicode/pull/21
      patches = (old.patches or []) ++ [
        (super.fetchpatch {
          name = "show-unicode1-name-as-fallback.patch";
          url = "https://github.com/garabik/unicode/pull/21/commits/2c11b705810a5a3a927e2b36ed6d32ce2867a6f7.patch";
          sha256 = "sha256-cVBXnsi7FGXki7woJj09k8joyP1695HsOTWktPtFg1c=";
        })
      ];
    });
    # custom patches
    direnv = super.direnv.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        (localPath ./patches/direnv-0001-reduce-verbosity.patch)
      ];
    });
    i3lock-color = super.i3lock-color.overrideAttrs (old: {
      src = super.fetchFromGitHub {
        owner = "sersorrel";
        repo = "i3lock-color";
        rev = "8ab09b8d3fdd87ac0b14a3f419281a4791fa2c78";
        sha256 = "1l25x4wx3ar6lfpxcm5whzpxyblcs8blf4gqi3vh2ynvn7cn1qib";
      };
    });
    i3status-rust = super.i3status-rust.overrideAttrs (old: rec {
      # TODO: remove version override after next release https://github.com/greshake/i3status-rust/issues/1848
      version = assert builtins.compareVersions super.i3status-rust.version "0.30.5" != 1; "unstable-2023-03-29";
      src = super.fetchFromGitHub {
        owner = "greshake";
        repo = "i3status-rust";
        rev = "7f033f78905b3e3bc43ffdaae3c3bdb62226737c";
        sha256 = "sha256-zl5hh0M/OnNnTpo+1P9W0BvZcjTVMHBTQQAvNTkN/m4=";
      };
      cargoDeps = old.cargoDeps.overrideAttrs (old': {
        inherit src;
        outputHash = "sha256-lpH4rd/Yj1vQsGG1FI+S3oUDOPLrH/TLrN+D2YHUEdg=";
      });
      patches = (old.patches or []) ++ [
        #(localPath ./patches/i3status-rust-0001-uptime-warning.patch) # TODO broken on 23.05
        #(localPath ./patches/i3status-rust-0002-kdeconnect-zero-battery.patch) # TODO broken on 23.05
        #(localPath ./patches/i3status-rust-0003-kdeconnect-disconnected-idle.patch) # TODO broken on 23.05
      ];
    });
    kitty = super.kitty.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        #(localPath ./patches/kitty-0001-sound-theme.patch) # TODO broken on 23.05
      ];
    });
    rhythmbox = super.rhythmbox.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        (localPath ./patches/rhythmbox-0001-no-pause-notification.patch)
      ];
    });
    rink = super.rink.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        (localPath ./patches/rink-0001-change-date-formats.patch)
        (localPath ./patches/rink-0002-amp-hour.patch)
      ];
    });
    # software not in nixpkgs
    uoyweek = super.rustPlatform.buildRustPackage {
      pname = "uoyweek";
      version = "0.1.0";
      src = super.fetchFromGitHub {
        owner = "sersorrel";
        repo = "uoyweek.rs";
        rev = "d32e4096dee51641270cb4b624d7b0727f101f42";
        sha256 = "17a2173myj6fxmgyaly6nz905b94vw6zr8qm5v2ig7yrxlqd9nnk";
      };
      cargoSha256 = "1xfgszxbj1ji0wpz01n9hhwnba7kxbbqk53r0sgxasxbzfmmknw5";
    };
    display-volume = super.rustPlatform.buildRustPackage {
      pname = "display-volume";
      version = "0.1.0";
      src = super.fetchFromGitHub {
        owner = "sersorrel";
        repo = "display-volume";
        rev = "318a70933869d3a5c50bce06bda2887c3c287e84";
        sha256 = "1gqyxggxwk87ddcsisb4s1rw8f9z8lyxg95py0nn77q18w6f6srg";
      };
      cargoSha256 = "1a8rm1hnw7gmbvaps9p0kcr3v0vm7a0ax31qcfsghhl3nckr4nkm";
      nativeBuildInputs = [
        super.autoPatchelfHook
      ];
      buildInputs = [
        super.libpulseaudio
      ];
    };
    file2img = super.callPackage (localPath ./programs/file2img.nix) {};
    fishPlugins = super.fishPlugins.overrideScope' (self': super': let
      meta = {
        pname = "fenv.rs";
        version = "unstable-2023-03-27";
        src = super.fetchFromGitHub {
          owner = "sersorrel";
          repo = "fenv.rs";
          rev = "de14458fb472d2832110df88dc5e2a5d9c12e684";
          sha256 = "1xjc8krq2yakdr2i9mvpsvc4sp9a34a14yvqxkp35s7zi0qwak3d";
        };
      };
      fenv = super.rustPlatform.buildRustPackage {
        inherit (meta) pname version src;
        cargoSha256 = "1mmd5s9gcx0wr2a37g7hc5rb354d3hhy8k29myvq5sw6917kgbhj";
      };
    in {
      foreign-env = super'.buildFishPlugin {
        inherit (meta) pname version src;
        preInstall = ''
          sed -i 's|_fenv|${fenv}/bin/_fenv|g' functions/fenv.fish
        '';
      };
    });
  })
]
