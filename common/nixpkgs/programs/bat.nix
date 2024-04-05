{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, less
, libiconv
, installShellFiles
, makeWrapper
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "bat";
  version = "unstable-2024-03-19";

  src = fetchFromGitHub {
    owner = "bash";
    repo = "bat";
    rev = "6213319adcc51d36e20788577ba0862fdae7114c";
    hash = "sha256-OqYdw+hSs43GDPhZ/Sun8uc4KJ6yE/ZgNhIKudR/16Y=";
  };
  cargoHash = "sha256-GH+5dCj7BcKcuwJ0jV6GHwXsac89hB9C1zFAmnDLsIg=";

  patches = [
    ./../patches/bat-0001-always-detect-colour-scheme.patch
  ];

  nativeBuildInputs = [ pkg-config installShellFiles makeWrapper ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  postInstall = ''
    installManPage $releaseDir/build/bat-*/out/assets/manual/bat.1
    installShellCompletion $releaseDir/build/bat-*/out/assets/completions/bat.{bash,fish,zsh}
  '';

  # Insert Nix-built `less` into PATH because the system-provided one may be too old to behave as
  # expected with certain flag combinations.
  postFixup = ''
    wrapProgram "$out/bin/bat" \
      --prefix PATH : "${lib.makeBinPath [ less ]}"
  '';

  # Skip test cases which depends on `more`
  checkFlags = [
    "--skip=alias_pager_disable_long_overrides_short"
    "--skip=config_read_arguments_from_file"
    "--skip=env_var_bat_paging"
    "--skip=pager_arg_override_env_noconfig"
    "--skip=pager_arg_override_env_withconfig"
    "--skip=pager_basic"
    "--skip=pager_basic_arg"
    "--skip=pager_env_bat_pager_override_config"
    "--skip=pager_env_pager_nooverride_config"
    "--skip=pager_more"
    "--skip=pager_most"
    "--skip=pager_overwrite"
    # Fails if the filesystem performs UTF-8 validation (such as ZFS with utf8only=on)
    "--skip=file_with_invalid_utf8_filename"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    testFile=$(mktemp /tmp/bat-test.XXXX)
    echo -ne 'Foobar\n\n\n42' > $testFile
    $out/bin/bat -p $testFile | grep "Foobar"
    $out/bin/bat -p $testFile -r 4:4 | grep 42
    rm $testFile

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "A cat(1) clone with syntax highlighting and Git integration";
    homepage = "https://github.com/sharkdp/bat";
    changelog = "https://github.com/sharkdp/bat/raw/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    mainProgram = "bat";
    maintainers = with maintainers; [ dywedir lilyball zowoq SuperSandro2000 ];
  };
}
