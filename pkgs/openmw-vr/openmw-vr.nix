{ pkgs, lib }:
let

  GL = "GLVND"; # or "LEGACY";

  bullet' = pkgs.bullet.overrideDerivation (old: {
    cmakeFlags = (old.cmakeFlags or [ ]) ++ [
      "-Wno-dev"
      "-DOpenGL_GL_PREFERENCE=${GL}"
      "-DUSE_DOUBLE_PRECISION=ON"
      "-DBULLET2_MULTITHREADING=ON"
    ];
  });

  #qtMkDerivation = pkgs.libsForQt5.callPackage ({ mkDerivation }: mkDerivation) {};

in

  pkgs.stdenv.mkDerivation {
    pname = "openmw_vr";
    version = "0.48.0";

    src = pkgs.fetchFromGitLab {
      owner = "madsbuvi";
      repo = "openmw";
      rev = "cac0667193434af3a419d3b14029d2956cf46f5d";
      hash = "sha256-oAr3Ii8ph8MbsxhLT3Q8W/rjdDvEDo5EuCFkIbzg+UI=";
    };

    postPatch = /*sh*/ ''
      sed '1i#include <memory>' -i components/myguiplatform/myguidatamanager.cpp ### gcc12
    '';

    buildInputs = with pkgs; [
      boost
      bullet'
      doxygen
      ffmpeg_6
      graphviz
      jsoncpp
      libglvnd
      luajit
      lz4
      mesa
      mygui
      openal
      openscenegraph
      recastnavigation
      SDL2
      unshield
      yaml-cpp
      libXdmcp
      libXrandr
      libXt
      libXxf86vm
    ];

    nativeBuildInputs = with pkgs; [
      cmake
      pkg-config
      python3
      libsForQt5.wrapQtAppsHook
    ];

    enableParallelBuilding = true;

    cmakeFlags = let
      openxr-sdk = pkgs.fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "OpenXR-SDK";
        rev = "1ca7bec6b531185530c9b4f1e7a50e1fd55e7641";
        hash = "sha256-JrmC4kPDqI06Vm6h216zyTCk0REkpxcvYbyIMTxf1C0=";
        postFetch = /*sh*/ ''
          ### PATCH openxr.pc.in TO FIX libdir= //PATH
          sed -i 's|libdir=\''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@|libdir=@CMAKE_INSTALL_FULL_LIBDIR@|' $out/src/loader/openxr.pc.in
        '';
      };
    in [
      "-DOpenGL_GL_PREFERENCE=LEGACY"
      "-DOPENMW_USE_SYSTEM_RECASTNAVIGATION=1"
      "-DFETCHCONTENT_SOURCE_DIR_OPENXR=${openxr-sdk}"
      "-DCMAKE_SKIP_BUILD_RPATH=ON"
      "-DBUILD_OPENMW_VR=ON"
    ];

    qtWrapperArgs = [ ''
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pkgs.libglvnd pkgs.libuuid pkgs.SDL2]}
    ''];

    installPhase = /*sh*/ ''
      runHook preInstall

      ### Run the default install phase provided by CMake
      cmake --build . --target install

      ### Copy the openmw_vr binary to the output directory.
      install -m755 ./openmw_vr $out/bin

      runHook postInstall
    '';


    meta = with lib; {
      description = "Unofficial VR open source engine reimplementation of the game Morrowind";
      homepage = "https://openmw.org";
      license = licenses.gpl3Plus;
      mainProgram = "openmw-launcher";
      maintainers = with maintainers; [ bndlfm ];
      platforms = platforms.linux;
    };
  }

