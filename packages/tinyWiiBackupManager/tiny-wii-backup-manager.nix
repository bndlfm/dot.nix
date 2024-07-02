{ lib, pkgs, fetchFromGitHub, rustPlatform }:
  rustPlatform.buildRustPackage rec {
    pname = "tiny-wii-backup-manager";
    version = "0.3.7";

    src = fetchFromGitHub {
      owner = "mq1";
      repo = "tiny-wii-backup-manager";
      rev = "master"; # You might want to use a specific commit hash or tag instead
      sha256 = lib.fakeSha256;
    };

    cargoHash = lib.fakeSha256;

    buildInputs = with pkgs; [
      gtk3
    ];

    buildPhase = ''
      # Add build commands here
      cargo build --release
    '';

    installPhase = ''
      # Add install commands here
      mkdir -p $out/bin
      cp tiny-wii-backup-manager $out/bin/
    '';

    meta = with pkgs.lib; {
      description = "Wii Backup Fusion";
      homepage = "https://github.com/larsenv/Wii-Backup-Fusion";
      license = licenses.gpl3; # Adjust if the license is different
      platforms = platforms.all;
    };
}
