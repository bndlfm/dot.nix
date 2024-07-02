{ lib, pkgs, fetchFromGitHub, rustPlatform }:
  rustPlatform.buildRustPackage rec {
    pname = "tiny-wii-backup-manager";
    version = "0.3.7";

    src = fetchFromGitHub {
      owner = "mq1";
      repo = "TinyWiiBackupManager";
      rev = "master"; # You might want to use a specific commit hash or tag instead
      sha256 = "sha256-EYJQzQ9iEmhdEgmPriaP9Oy5n5pnFNOFqsnHMN9+vcY=";
    };

    cargoDeps = rustPlatform.importCargoLock {
      inherit src;
      lockFile = ./Cargo.lock;
    };
#    postPatch = ''
#      ln -s ${./Cargo.lock} Cargo.lock
#    '';

    nativeBuildInputs = with pkgs; [ pkg-config ];

    buildInputs = with pkgs; [
      gtk3
    ] ++ lib.optionals stdenv.isLinux [ openssl ];

    buildPhase = ''
      cargo build --release
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp tiny-wii-backup-manager $out/bin/
    '';

    meta = with pkgs.lib; {
      description = "Tiny Wii Backup Manager";
      homepage = "https://github.com/mq1/TinyWiiBackupManager";
      license = licenses.gpl3; # Adjust if the license is different
      platforms = platforms.all;
    };
}

#OPENSSL_NO_VENDOR = 1

#cargoLock = {
# lockFile = ./Cargo.lock;
# allowBuiltinFetchGit = true;
#};
