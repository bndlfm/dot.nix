{ pkgs ? import <nixpkgs> {} }:

pkgs.buildGoModule {
  pname = "pass2bitwarden";
  version = "1.0.0";

  # Use the current directory as the source.
  src = pkgs.fetchFromGitHub {
    owner = "sklukin";
    repo = "pass2bitwarden";
    rev = "669aef9e51677676f76a4b47fda69b31f030eba9";
    hash = "";
  };

  # This hash is computed from the go.mod and go.sum files.
  # On the first build it will likely fail with a hash mismatch;
  # you can then run:
  #
  #   nix-prefetch --unpack .
  #
  # to compute the correct hash and replace the placeholder below.
  modSha256 = "sha256-PLACEHOLDER";

  # Optionally, disable vendoring if you are not using a vendor directory.
  vendorSha256 = null;

  # You can enable tests (if any exist) by setting doCheck = true.
  doCheck = false;
}
