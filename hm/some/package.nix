{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
}:

rustPlatform.buildRustPackage {
  pname = "some";
  version = "unstable-2023-01-23";

  src = fetchFromGitHub {
    owner = "sersorrel";
    repo = "some.rs";
    rev = "fa864cc06cb6c4af4644adb34957f6ab423526af";
    sha256 = "1jnq14z7r2wgpxnmr3g2jfrz8l13a9pfxjdj4wlj8hbni5wag37j";
  };

  cargoHash = "sha256-Ki9WoO4BSqO1IGKppCJJXFT3OvzJt1HkA/wPUdE3WdE=";
}
