{ lib
, autoPatchelfHook
, copyDesktopItems
, dbus
, fontconfig
, freetype
, libGL
, libxkbcommon
, makeDesktopItem
, makeWrapper
, ncurses6
, python310
, requireFile
, stdenv
, unzip
, wayland-scanner
, xorg
, zlib
}:

stdenv.mkDerivation rec {
  pname = "binary-ninja";
  version = "3.3.3996";

  src = requireFile rec {
    name = "BinaryNinja-personal.zip";
    url = "https://binary.ninja/recover/";
    sha256 = "2109908f33fa03290a8a3fa54ff2de56239c4767fc1b38e98879f0b598cf3166";
    message = ''
      Stable download URLs for Binary Ninja are not available.
      Please visit ${url} and find the download link for ${name} (version ${version}),
      then add it to the Nix store with this command:

        nix-prefetch-url --name ${name} --type sha256 <URL>
    '';
  };

  buildInputs = [
    dbus # libdbus-1.so.3
    fontconfig.lib # libfontconfig.so.1
    freetype # libfreetype.so.6
    libGL # libGL.so.1
    libxkbcommon # libxkbcommon.so.0
    stdenv.cc.cc.lib # libstdc++.so.6
    wayland-scanner.out # libwayland-client.so.0 libwayland-egl.so.1
    xorg.xcbutilimage # libxcb-image.so.0
    xorg.xcbutilkeysyms # libxcb-keysyms.so.1
    xorg.xcbutilrenderutil # libxcb-keysyms.so.1
    xorg.xcbutilwm # libxcb-icccm.so.4
    zlib # libz.so.1
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
    unzip
  ];

  prePatch = ''
    addAutoPatchelfSearchPath $out/opt
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -r * $out/opt
    chmod +x $out/opt/binaryninja

    # https://github.com/Vector35/binaryninja-api/issues/464
    # path confirmed via strace binaryninja &| kg -C10 python
    ln -s ${python310}/lib/libpython3.10.so.1.0 $out/opt/

    mkdir -p $out/share/pixmaps
    cp docs/img/logo.png $out/share/pixmaps/binary-ninja.png

    mkdir -p $out/bin
    makeWrapper $out/opt/binaryninja $out/bin/binaryninja

    runHook postInstall
  '';

  autoPatchelfIgnoreMissingDeps = [
    "libQt6Qml.so.6"
    "libQt6PrintSupport.so.6"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "binary-ninja";
      desktopName = "Binary Ninja";
      icon = "binary-ninja";
      exec = "binaryninja";
    })
  ];
}
