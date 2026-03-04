{
  stdenv,
  fetchurl,
  lib,
}:
let
  version = "0.1.42";
  vVersion = "v${version}";

  platform = if stdenv.hostPlatform.isDarwin then "darwin" else "linux";
  arch = if stdenv.hostPlatform.isAarch64 then "arm64" else "amd64";

  url = "https://storage.googleapis.com/jules-cli/${vVersion}/jules_external_${vVersion}_${platform}_${arch}.tar.gz";

  sha256 =
    {
      "x86_64-linux" = "00yilwvk4ygmq9ky4zdkk6gbdk23g76vik2dxwjbpfc9iwnbvkkk";
      "aarch64-linux" = "1z7vrmz92wxnq2kblb5d0rahiji27d2p7jczxb32sl3idsih87bh";
      "x86_64-darwin" = "0x0nw4kbg99m0df31vjj6s6lmx7vz3x44sygk04r7mm8my9qg2h9";
      "aarch64-darwin" = "0m4jmvi3ww8g16cn79wq395h5z1x8zz5sd06dv7d5p82sk963rw9";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

in
stdenv.mkDerivation {
  pname = "jules";
  inherit version;

  src = fetchurl {
    inherit url sha256;
  };

  # The tarball contains 'jules' and 'run.cjs'
  # We only need the 'jules' binary
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -Dm755 jules $out/bin/jules
    runHook postInstall
  '';

  meta = with lib; {
    description = "Jules, the asynchronous coding agent from Google";
    homepage = "https://jules.google";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "jules";
  };
}
