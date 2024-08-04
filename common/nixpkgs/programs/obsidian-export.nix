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

  cargoHash = "sha256-XYk7AW02Hhn6SVX6UQpZ054N1xXdQFS8XxllWMMxumY=";
}
