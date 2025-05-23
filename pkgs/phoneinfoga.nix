{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "phoneinfoga";
  version = "2.11.0"; # You can change this to the desired version/tag

  src = fetchFromGitHub {
    owner = "sundowndev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YOUR_SHA256_HASH_HERE"; # Replace with the actual SRI hash
  };

  # The go.mod file indicates the Go version used.
  # From .github/workflows/build.yml, it's 1.20.6, let's use a recent stable one.
  # You might need to adjust this based on the specific version's go.mod.
  # Nixpkgs will often handle this automatically if a go.mod exists.

  vendorSha256 = null; # or run nix-prefetch-git --print-sha256 <url_to_tarball>
                       # and then use lib.fakeSha256 to get the vendorSha256
                       # or use a fixed-output derivation for go mod vendor

  # From the Makefile and .github/workflows/build.yml,
  # it seems there's a step to build static assets for the web client.
  # This example focuses on the main Go binary.
  # For the web client, you'd typically need Node.js and yarn.
  # preBuild = ''
  #   (cd web/client && yarn install --immutable && yarn build)
  #   make build # This might try to do too much, often just `go build` is needed here.
  # '';

  # The main package seems to be at the root.
  # If main.go is in a subdirectory like cmd/phoneinfoga, adjust this.
  subPackages = [ "." ];

  ldflags = [
    "-s" "-w"
    "-X github.com/sundowndev/phoneinfoga/v2/build.Version=v${version}"
  ];

  meta = with lib; {
    description = "Advanced information gathering & OSINT framework for phone numbers";
    homepage = "https://github.com/sundowndev/phoneinfoga";
    license = licenses.gpl3Only; # Based on the LICENSE file
    maintainers = with maintainers; [ ]; # Add your name here
    platforms = platforms.linux ++ platforms.darwin;
  };
}
