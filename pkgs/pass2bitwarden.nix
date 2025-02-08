{ pkgs ? import <nixpkgs> {} }:

pkgs.buildGoModule {
  pname = "pass2bitwarden";
  version = "1.0.0";

  # Use the current directory as the source.
  src = pkgs.fetchFromGitHub {
    owner = "mtrovo";
    repo = "pass2bitwarden";
    rev = "06a0a64a8dc08a5f4ec72ec32ceeabecb1d9a80f";
    hash = "sha256-7URGaJqT9TNBaRvHnmwgdk2r2aAyGn891GBQ1rhbh+I=";
  };

  #GO111MODULE="off";

  #old hash sha256-0Fugk71REFxwhgY+Nr3rvfveNryJyMZBW42FH0b6xZ8=
  # This hash is computed from the go.mod and go.sum files.
  # On the first build it will likely fail with a hash mismatch;
  # you can then run:
  #
  #   nix-prefetch --unpack .
  #
  # to compute the correct hash and replace the placeholder below.
  #modSha256 = "sha256-PLACEHOLDER";

  # Optionally, disable vendoring if you are not using a vendor directory.
  vendorHash = null;

  # You can enable tests (if any exist) by setting doCheck = true.
  doCheck = false;
}
