{ stdenv
, fetchFromGitHub
, cmake
, meson
, ninja
, vulkan-headers
, vulkan-loader
, pkg-config
, wine
, mingw-w64
, dotnet-sdk
, python3
, bepInEx
, git
}:

stdenv.mkDerivation rec {
  pname = "latencyflex";
  version = "unstable-2024-01-21";

  src = fetchFromGitHub {
    owner = "ishitatsuyuki";
    repo = "LatencyFleX";
    rev = "d309d38774b9095d55e65497957d5c10904b506b"; # Replace with a specific commit if needed
    hash = "sha256-x4g7L15hI6d0y4a39T1+hY2XJ6x9I0pT1mI5hE8jJ5c="; # Replace with the correct hash
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    meson
    ninja
    pkg-config
    python3
    git
  ];

  buildInputs = [
    vulkan-headers
    vulkan-loader
  ];

  # Layer build
  postPatch = ''
    # Patch for older distros using old Wine layout.
    # This can be removed when targeting newer distributions.
    substituteInPlace layer/wine/meson_options.txt \
      --replace "false" "true"
  '';

  buildPhase = ''
    runHook preBuild

    # Build layer
    (
      cd layer
      meson setup build \
        --prefix=$out \
        -Dperfetto=false
      meson compile -C build
    )

    # Build wine (64-bit)
    export LIBRARY_PATH="$out/lib"
    (
      cd layer/wine
      meson setup build-wine64 \
        --prefix=$out \
        --cross-file cross-wine64.txt
      meson compile -C build-wine64
    )

    # Build wine (mingw-w64)
    (
      cd layer/wine
      meson setup build-mingw64 \
        --prefix=$out \
        --cross-file cross-mingw64.txt
      meson compile -C build-mingw64
    )

    # Build unity
    (
      cd layer/unity
      export HOME=$(mktemp -d)
      dotnet build --configuration Release -p:UnityTarget=2018.1 -p:UnityRuntime=Mono LatencyFleX.csproj -o $out/unity/mono-2018.1
      dotnet build --configuration Release -p:UnityTarget=2019.3 -p:UnityRuntime=Mono LatencyFleX.csproj -o $out/unity/mono-2019.3
      dotnet build --configuration Release -p:UnityTarget=2019.3 -p:UnityRuntime=IL2CPP LatencyFleX.csproj -o $out/unity/il2cpp-2019.3
    )

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Install layer
    (
      cd layer
      meson install -C build --no-rebuild
    )

    # Install wine
    (
      cd layer/wine
      meson install -C build-wine64 --no-rebuild
      meson install -C build-mingw64 --no-rebuild
    )

    runHook postInstall
  '';

  # Add wine to buildInputs only if cross-compiling or explicitly requested.
  # This avoids rebuilds when wine is updated.
  propagatedBuildInputs = stdenv.lib.optionals stdenv.hostPlatform.isCross [
    wine
    mingw-w64
    dotnet-sdk
  ];

  doCheck = false; # No tests available

  meta = with stdenv.lib; {
    description = "Vendor agnostic latency reduction middleware";
    homepage = "https://github.com/ishitatsuyuki/LatencyFleX";
    license = licenses.asl20;
    maintainers = [ maintainers.your-github-username ]; # Replace with your GitHub username
    platforms = platforms.linux;
  };
}
