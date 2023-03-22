{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "file2img";
  version = "2021-01-28";
  src = fetchFromGitHub {
    owner = "lunasorcery";
    repo = "file2img";
    rev = "ed9713f9b107707c2d4ec163beb49121f065819a";
    sha256 = "07im3clnbanxkrycbwkilqnvgk1wgaqy0b12kk920rr3267pf5rm";
  };
  installPhase = ''
    mkdir -p $out/bin
    cp file2img $out/bin
  '';
}
