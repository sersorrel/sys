{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
}:

rustPlatform.buildRustPackage {
  pname = "some";
  version = "unstable-2025-05-04";

  src = fetchFromGitHub {
    owner = "keysmashes";
    repo = "some.rs";
    rev = "6fabc71fa75104bceccb0ce6c4087a8089fd7786";
    sha256 = "12f07qlkzqlw7lnndpad2rks9z68ngw9alcshdldrsm39fvai0q9";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-5qe6E/5HkqZjpv1P7810/iFV+j4cdbpym1o5duee6/k=";
}
