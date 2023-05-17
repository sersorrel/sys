{ stdenv, fetchFromGitHub, xxd }:

stdenv.mkDerivation {
  pname = "fusee-nano";
  version = "unstable-2023-05-04";
  src = fetchFromGitHub {
    owner = "DavidBuchanan314";
    repo = "fusee-nano";
    rev = "5ed915460f5e8c54f071a9a227f805f3280baa9c";
    sha256 = "sha256-H2COke7mCJ5fKkly3qp0mk/qSOlLvzo/CHvjVghRFd0=";
  };
  nativeBuildInputs = [
    xxd
  ];
  makeFlags = [ "PREFIX=$(out)/bin" ];
  preInstall = ''
    mkdir -p $out/bin
  '';
}
