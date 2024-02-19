{ stdenv
, lib
, fetchurl
, substituteAll
, autoreconfHook
, pkg-config
, intltool
, rename
, babl
, gegl
, gtk2
, glib
, gdk-pixbuf
, isocodes
, pango
, cairo
, freetype
, fontconfig
, lcms
, libpng
, libjpeg
, libjxl
, poppler
, poppler_data
, libtiff
, libmng
, librsvg
, libwmf
, libxslt
, zlib
, libzip
, ghostscript
, aalib
, shared-mime-info
, libexif
, gettext
, makeWrapper
, gtk-doc
, xorg
, glib-networking
, libmypaint
, gexiv2
, harfbuzz
, mypaint-brushes1
, libwebp
, libheif
, libgudev
, openexr
, desktopToDarwinBundle
, AppKit
, Cocoa
, gtk-mac-integration-gtk2
, withPython ? false
, python2
}:

let
  python = python2.withPackages (pp: [ pp.pygtk ]);
in stdenv.mkDerivation (finalAttrs: {
  pname = "glimmer";
  version = "2.10.36";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "http://download.gimp.org/pub/gimp/v${lib.versions.majorMinor finalAttrs.version}/gimp-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-PTvDxppL2zrqm6LVOF7ZjqA5U/OFeq/R1pdgEe1827I=";
  };

  patches = [
    # to remove compiler from the runtime closure, reference was retained via
    # glimmer --version --verbose output
    (substituteAll {
      src = ./remove-cc-reference.patch;
      cc_version = stdenv.cc.cc.name;
    })

    # Use absolute paths instead of relying on PATH
    # to make sure plug-ins are loaded by the correct interpreter.
    ./hardcode-plugin-interpreters.patch
    # Remove duplicate translations produced by the "GNU Image Manipulation Program" -> "Glimmer" substitution
    ./dedupe-translations.patch
  ];

  nativeBuildInputs = [
    autoreconfHook # hardcode-plugin-interpreters.patch changes Makefile.am
    pkg-config
    intltool
    gettext
    makeWrapper
    gtk-doc
    rename
  ] ++ lib.optionals stdenv.isDarwin [
    desktopToDarwinBundle
  ];

  buildInputs = [
    babl
    gegl
    gtk2
    glib
    gdk-pixbuf
    pango
    cairo
    gexiv2
    harfbuzz
    isocodes
    freetype
    fontconfig
    lcms
    libpng
    libjpeg
    libjxl
    poppler
    poppler_data
    libtiff
    openexr
    libmng
    librsvg
    libwmf
    libxslt
    zlib
    libzip
    ghostscript
    aalib
    shared-mime-info
    libwebp
    libheif
    libexif
    xorg.libXpm
    glib-networking
    libmypaint
    mypaint-brushes1
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    Cocoa
    gtk-mac-integration-gtk2
  ] ++ lib.optionals stdenv.isLinux [
    libgudev
  ] ++ lib.optionals withPython [
    python
    # Duplicated here because python.withPackages does not expose the dev output with pkg-config files
    python2.pkgs.pygtk
  ];

  # needed by glimmer-2.0.pc
  propagatedBuildInputs = [
    gegl
  ];

  configureFlags = [
    "--without-webkit" # old version is required
    "--disable-check-update"
    "--with-bug-report-url=https://github.com/NixOS/nixpkgs/issues/new"
    "--with-icc-directory=/run/current-system/sw/share/color/icc"
    # fix libdir in pc files (${exec_prefix} needs to be passed verbatim)
    "--libdir=\${exec_prefix}/lib"
  ] ++ lib.optionals (!withPython) [
    "--disable-python" # depends on Python2 which was EOLed on 2020-01-01
  ];

  enableParallelBuilding = true;

  doCheck = true;

  env = {
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-DGDK_OSX_BIG_SUR=16";

    # Check if librsvg was built with --disable-pixbuf-loader.
    PKG_CONFIG_GDK_PIXBUF_2_0_GDK_PIXBUF_MODULEDIR = "${librsvg}/${gdk-pixbuf.moduleDir}";
  };

  postUnpack = let
    ignoredFiles = "\\! -name '*.png' \\! -name '*.xcf' \\! -name '*.gih' \\! -name '*.gbr' \\! -name '*.pat' \\! -name '*.pgm' \\! -name '*.ppm'";
    # ggr, gpl, scm, gdyn, gtp, vbr are text files
    # this sucks!
  in ''
    mv gimp-${finalAttrs.version} glimmer-${finalAttrs.version}
    sourceRoot="glimmer-${finalAttrs.version}"
    echo "no it's not, it's $sourceRoot"

    sed -i 's/GiMP/Glimmer/g' glimmer-${finalAttrs.version}/po-plug-ins/sk.po # upstream typo?
    # remove obsolete entries from some po files, because they cause conflicts when the case is squashed
    sed -i '/^#~/d' glimmer-${finalAttrs.version}/po-plug-ins/*.po glimmer-${finalAttrs.version}/po-tips/*.po

    # GIMP_ -> GLIMMER_: leave stuff in code in allcaps
    # GIMP/ -> GLIMMER/: see e.g. line 446 of pdb/app.pl (without the capture group, this is a very bad pattern! it would match e.g. the definition of GLIMMER_DBUS_INTERFACE_PATH, which should *not* be all-caps)
    find glimmer-${finalAttrs.version} -type f ${ignoredFiles} -exec perl -i -pe 's/gimp(?! xcf)/glimmer/g' {} + # avoid changing the XCF file magic number
    find glimmer-${finalAttrs.version} -type f ${ignoredFiles} -exec perl -i -pe 's/Gimp/Glimmer/g' {} +
    find glimmer-${finalAttrs.version} -type f ${ignoredFiles} -exec perl -i -pe 's/GIMP_/GLIMMER_/g' {} +
    find glimmer-${finalAttrs.version} -type f ${ignoredFiles} -exec perl -i -pe 's@(s/(\\*[^\\/]|(\\\\)*/)*)GIMP/@\1GLIMMER/@g' {} +
    find glimmer-${finalAttrs.version} -type f ${ignoredFiles} -exec perl -i -pe 's/GIMP/Glimmer/g' {} +
    find glimmer-${finalAttrs.version} -type f ${ignoredFiles} -exec perl -i -pe 's/GNU Image Manipulation Program/Glimmer/g' {} +
    find glimmer-${finalAttrs.version} -depth -execdir rename 's/gimp/glimmer/g' {} +
    find glimmer-${finalAttrs.version} -depth -execdir rename 's/Gimp/Glimmer/g' {} +
    find glimmer-${finalAttrs.version} -depth -execdir rename 's/GIMP_/GLIMMER_/g' {} +
    find glimmer-${finalAttrs.version} -depth -execdir rename 's/GIMP/Glimmer/g' {} +

    # fix up a test, which expects to see specific strings saved in an XCF file saved to source control
    sed -i 's@app/tests/test-xcf.c in the Glimmer@app/tests/test-xcf.c in the GIMP@g' glimmer-${finalAttrs.version}/app/tests/test-xcf.c
    sed -i 's/opened and inspected in Glimmer/opened and inspected in GIMP/g' glimmer-${finalAttrs.version}/app/tests/test-xcf.c

    # fix known parasites from devel-docs/parasites.txt
    # the lookaheads avoid matching filenames
    find glimmer-${finalAttrs.version} -type f ${ignoredFiles} -exec perl -i -pe 's/glimmer-comment(?!\.)/gimp-comment/g' {} +
    find glimmer-${finalAttrs.version} -type f ${ignoredFiles} -exec perl -i -pe 's/glimmer-brush-name(?!\.)/gimp-brush-name/g' {} +
    find glimmer-${finalAttrs.version} -type f ${ignoredFiles} -exec perl -i -pe 's/glimmer-brush-pipe-name(?!\.)/gimp-brush-pipe-name/g' {} +
    find glimmer-${finalAttrs.version} -type f ${ignoredFiles} -exec perl -i -pe 's/glimmer-brush-pipe-parameters(?!\.)/gimp-brush-pipe-parameters/g' {} +
    find glimmer-${finalAttrs.version} -type f ${ignoredFiles} -exec perl -i -pe 's/glimmer-image-grid(?!\.)/gimp-image-grid/g' {} +
    find glimmer-${finalAttrs.version} -type f ${ignoredFiles} -exec perl -i -pe 's/glimmer-pattern-name(?!\.)/gimp-pattern-name/g' {} +
    find glimmer-${finalAttrs.version} -type f ${ignoredFiles} -exec perl -i -pe 's/glimmer-metadata(?!\.)/gimp-metadata/g' {} +
    find glimmer-${finalAttrs.version} -type f ${ignoredFiles} -exec perl -i -pe 's/glimmer-text-layer(?!\.)/gimp-text-layer/g' {} +

    # attempt to delete wilber (this doesn't work)
    # sed -i 's/wilber_path\[] = ".*";/wilber_path[] = "";/g' glimmer-${finalAttrs.version}/app/widgets/glimmercairo-wilber.c
    # sed -i 's/eyes_path\[] = ".*";/eyes_path[] = "";/g' glimmer-${finalAttrs.version}/app/widgets/glimmercairo-wilber.c
  '';

  preConfigure = ''
    # The check runs before glib-networking is registered
    export GIO_EXTRA_MODULES="${glib-networking}/lib/gio/modules:$GIO_EXTRA_MODULES"
  '';

  postFixup = ''
    wrapProgram $out/bin/glimmer-${lib.versions.majorMinor finalAttrs.version} \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';

  passthru = {
    # The declarations for `glimmer-with-plugins` wrapper,
    # used for determining plug-in installation paths
    majorVersion = "${lib.versions.major finalAttrs.version}.0";
    targetLibDir = "lib/glimmer/${finalAttrs.passthru.majorVersion}";
    targetDataDir = "share/glimmer/${finalAttrs.passthru.majorVersion}";
    targetPluginDir = "${finalAttrs.passthru.targetLibDir}/plug-ins";
    targetScriptDir = "${finalAttrs.passthru.targetDataDir}/scripts";

    # probably its a good idea to use the same gtk in plugins ?
    gtk = gtk2;

    python2Support = withPython;
  };

  meta = with lib; {
    description = "An image editor, rebranded";
    maintainers = with maintainers; [ ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    mainProgram = "glimmer";
  };
})
