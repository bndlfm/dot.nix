{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "phoneinfoga";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "sundowndev";
    repo = pname;
    rev = "v${version}";
    # This hash is for the source tarball itself
    hash = "sha256-jjgRgpwT1n5TUQYnqsGkyfaJ6q7NJzhIm5/VToz5Luc=";
  };

  # Tell buildGoModule to fetch dependencies based on go.mod and go.sum,
  # ignoring any vendor directory in src.
  proxyVendor = true;

  # This is the hash of the vendored dependencies that Nix will download.
  # You need to calculate this.
  # STEP 1: Use a placeholder like lib.fakeSha256 or a clearly bogus hash.
  vendorSha256 = lib.fakeSha256; # Or "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  # STEP 2: After building, Nix will tell you the correct hash. Update this line.
  # For example: vendorSha256 = "sha256-yourCalculatedHashWillGoHere";

  # It's good practice to remove the potentially problematic vendor directory
  # from the source when using proxyVendor = true.
  postPatch = ''
    rm -rf vendor
    # Optionally, if go.sum is also inconsistent (though less likely to be the primary issue here):
    # go mod tidy # This would require 'go' in nativeBuildInputs for postPatch
  '';

  # The main package seems to be at the root.
  subPackages = [ "." ];

  ldflags = [
    "-s" "-w"
    "-X github.com/sundowndev/phoneinfoga/v2/build.Version=v${version}"
  ];

  meta = with lib; {
    description = "Advanced information gathering & OSINT framework for phone numbers";
    homepage = "https://github.com/sundowndev/phoneinfoga";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ]; # Add your Nixpkgs/GitHub username
    platforms = platforms.linux ++ platforms.darwin;
  };
}
