{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, git
}:

stdenv.mkDerivation {
  pname = "git-fast-forward-all";
  version = "unstable-2020-05-07";
  src = fetchFromGitHub {
    owner = "changyuheng";
    repo = "git-fast-forward-all-branches";
    rev = "8406978fd1a34df0f4fb42e9853cd7f2fdb67601";
    sha256 = "1vhii1kp3hqk3hwc84qz77bz8bhrv8sg8khgisqpk3idld37jz48";
  };
  patches = [
    (
      builtins.toFile "dont-fetch-and-ignore-unclean.patch" ''
        --- a/git-fast-forward-all
        +++ b/git-fast-forward-all
        @@ -52,17 +52,6 @@ fast_forward_all() {
           return "$ret"
         }

        -fetch_all
        -excode=$?
        -[ "$excode" -eq 0 ] || {
        -  exit "$excode"
        -}
        -
        -if output=$(git status --porcelain) && [ -n "$output" ]; then
        -  echo "Skipped: repo is not clean"
        -  exit $EEXIST
        -fi
        -
         fast_forward_all
         excode=$?
         [ "$excode" -eq 0 ] || {
      ''
    )
  ];
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    install -Dm755 -t $out/bin git-fast-forward-all
  '';
  postFixup = ''
    wrapProgram $out/bin/git-fast-forward-all --prefix PATH : ${lib.makeBinPath [ git ]}
  '';
  meta = {
    license = [ lib.licenses.mpl20 ];
  };
}
