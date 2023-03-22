{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "obsidian-export";
  version = "22.11.0";

  src = fetchFromGitHub {
    owner = "zoni";
    repo = pname;
    rev = "v${version}";
    sha256 = "05s95ajd64xj3p6rvsbvklwgybi9ngs84pjdr862prf0h14jkxl5";
  };

  cargoSha256 = "0rms671mhr8rbyy58h6x2pbhv7nkb4553yjm97x1j7indl0kp2ax";
}
