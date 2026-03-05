{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
  autoPatchelfHook,
}:

let
  websocket-src = fetchFromGitHub {
    owner = "karlseguin";
    repo = "websocket.zig";
    rev = "97fefafa59cc78ce177cff540b8685cd7f699276";
    hash = "sha256-6fGZphAT4/MnEHjjqzUx/oUa07TBvLPl/58pyHHwq+M=";
  };
in
stdenv.mkDerivation rec {
  pname = "nullclaw";
  version = "2026.3.4";

  src = fetchFromGitHub {
    owner = "nullclaw";
    repo = "nullclaw";
    rev = "a9b04a1a10a5341d5c4da16a8939017413a36b18";
    hash = "sha256-0ZRx6n8LZCqDwhUOgwo8ShSkHWfgkU5npjSuWY9P4Yc=";
  };

  nativeBuildInputs = [
    zig
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  # Populate Zig cache with dependencies
  preBuild = ''
    export ZIG_GLOBAL_CACHE_DIR=$TMPDIR/zig-cache
    mkdir -p $ZIG_GLOBAL_CACHE_DIR/p/websocket-0.1.0-ZPISdRlzAwBB_Bz2UMMqxYqF6YEVTIBoFsbzwPUJTHIc
    cp -r ${websocket-src}/* $ZIG_GLOBAL_CACHE_DIR/p/websocket-0.1.0-ZPISdRlzAwBB_Bz2UMMqxYqF6YEVTIBoFsbzwPUJTHIc/
  '';

  buildPhase = ''
    runHook preBuild
    zig build -Doptimize=ReleaseSmall --prefix $out
    runHook postBuild
  '';

  # Zig build --prefix $out already installs everything to $out/bin, $out/lib etc.
  dontInstall = true;

  meta = with lib; {
    description = "Fastest, smallest, and fully autonomous AI assistant infrastructure";
    homepage = "https://github.com/nullclaw/nullclaw";
    license = licenses.mit;
    mainProgram = "nullclaw";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
