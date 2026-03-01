{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  wrapGAppsHook3,
  webkit2gtk_4_1,
  gtk3,
  libayatana-appindicator,
  librsvg,
  openssl,
  dbus,
  glib,
  libgit2,
  sqlite,
  fetchPnpmDeps,
  pnpm,
  nodejs,
  makeWrapper,
  git,
}:

let
  pname = "schaltwerk";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "2mawi2";
    repo = "schaltwerk";
    rev = "v${version}";
    hash = "sha256-166r7l4hk3hn0syvaj5p3pgpszxvkp9bvlwls98zx8cghzz3m81q";
  };

  frontend = stdenv.mkDerivation {
    pname = "${pname}-frontend";
    inherit version src;

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
      git
    ];

    pnpmDeps = fetchPnpmDeps {
      pname = "${pname}-frontend-deps";
      inherit version src;
      pnpm = pnpm;
      lockfile = ./pnpm-lock.yaml;
      hash = lib.fakeHash;
    };

    buildPhase = ''
      runHook preBuild
      pnpm run build
      runHook postBuild
    '';

    installPhase = ''
      cp -r dist $out
    '';
  };

  mcp-server = stdenv.mkDerivation {
    pname = "${pname}-mcp-server";
    inherit version src;

    sourceRoot = "${src.name}/mcp-server";

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
      git
    ];

    pnpmDeps = fetchPnpmDeps {
      pname = "${pname}-mcp-server-deps";
      inherit version src;
      pnpm = pnpm;
      sourceRoot = "${src.name}/mcp-server";
      lockfile = ./mcp-pnpm-lock.yaml;
      hash = lib.fakeHash;
    };

    buildPhase = ''
      runHook preBuild
      pnpm run build
      runHook postBuild
    '';

    installPhase = ''
      mkdir -p $out
      cp -r build package.json node_modules $out/
    '';
  };

in
rustPlatform.buildRustPackage {
  inherit pname version src;

  sourceRoot = "${src.name}/src-tauri";

  cargoHash = lib.fakeHash;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    wrapGAppsHook3
    makeWrapper
  ];

  buildInputs = [
    webkit2gtk_4_1
    gtk3
    libayatana-appindicator
    librsvg
    openssl
    dbus
    glib
    libgit2
    sqlite
  ];

  postPatch = ''
    # Disable sccache in cargo config if it exists
    if [ -f ../.cargo/config.toml ]; then
      sed -i 's/rustc-wrapper = "sccache"/# rustc-wrapper = "sccache"/' ../.cargo/config.toml
    fi

    # Patch MCP server path in Rust to point to the nix store location
    substituteInPlace src/services/mcp.rs \
      --replace 'let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));' 'let project_root = PathBuf::from("'$out'/share/schaltwerk");' \
      --replace 'let project_root = manifest_dir.parent().ok_or_else(|| "Failed to get project root".to_string())?.to_path_buf();' ""
  '';

  preBuild = ''
    # Link frontend assets into the expected location for Tauri
    ln -s ${frontend} ../dist
  '';

  postInstall = ''
    # Install MCP server
    mkdir -p $out/share/schaltwerk/mcp-server
    cp -r ${mcp-server}/* $out/share/schaltwerk/mcp-server/
  '';

  meta = with lib; {
    description = "AI-powered git worktree session manager for isolated development environments";
    homepage = "https://github.com/2mawi2/schaltwerk";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "schaltwerk";
    maintainers = [ ];
  };
}
