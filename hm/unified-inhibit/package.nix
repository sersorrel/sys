{
  gcc12Stdenv,
  fetchFromGitHub,
  dbus,
  xorg,
  pkgconf,
}:

# from https://github.com/wentam/unified-inhibit/blob/46d23825fec7cec4b63cbcbdb3421fa56027997c/flake.nix
gcc12Stdenv.mkDerivation {
  pname = "unified-inhibit";
  version = "unstable-2023-04-06";

  src = fetchFromGitHub {
    owner = "wentam";
    repo = "unified-inhibit";
    rev = "46d23825fec7cec4b63cbcbdb3421fa56027997c";
    sha256 = "sha256-tK5vyhT8q2h6D3/3B8iN09smG4ytnEi0NWgS9t6d44E=";
  };

  buildInputs = [ dbus xorg.libX11 xorg.libXScrnSaver ];
  nativeBuildInputs = [ pkgconf ];
  doCheck = true;
  buildPhase = ''make -j12 prefix=$out'';
  installPhase = ''make install prefix=$out'';
  checkPhase = ''
    mkdir -p test
    cp $src/test/dbus.conf ./test
    make test
  '';
}
