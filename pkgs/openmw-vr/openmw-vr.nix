{ lib
, stdenv
, fetchFromGitLab
, fetchFromGitHub
, git
, cmake
, pkg-config
, wrapQtAppsHook
, SDL2
, CoreMedia
, VideoToolbox
, VideoDecodeAcceleration
, boost
, bullet
# Please unpin this on the next OpenMW release.
, ffmpeg_6
, libXt
, luajit
, lz4
, mygui
, openal
, openscenegraph
, recastnavigation
, unshield
, yaml-cpp
}:

let

  pkgs = import <nixpkgs> {};

  mkDerivation = pkgs.libsForQt5.callPackage ({ mkDerivation }: mkDerivation) {};

  GL = "GLVND"; # or "LEGACY";

  bullet' = bullet.overrideDerivation (old: {
    cmakeFlags = (old.cmakeFlags or [ ]) ++ [
      "-Wno-dev"
      "-DOpenGL_GL_PREFERENCE=${GL}"
      "-DUSE_DOUBLE_PRECISION=ON"
      "-DBULLET2_MULTITHREADING=ON"
    ];
  });

  openxr_sdk = fetchFromGitHub{
    owner = "KhronosGroup";
    repo = "OpenXR-SDK";
    rev = "b7ada0bdecd9830f27c2221dad6f0bb933c64f15";
    hash = "sha256-YsT6z0uymEF35US1ux7E4JOAK6YeOzryulYVGRi0EjA=";
  };

in

  mkDerivation {
    pname = "openmw-vr";
    version = "0.48.0";

    src = fetchFromGitLab {
      owner = "madsbuvi";
      repo = "openmw";
      rev = "770584c5112e46be1a00b9e357b0b7f6b449cac5";
      hash = "sha256-C8lFjKIdbHyvRcZzJNUj8Lif9IqNvuYURwRMpb4sxiQ=";
      fetchSubmodules = true;
    };

    postPatch = /* sh */ ''
      ### gcc12
        sed '1i#include <memory>' -i components/myguiplatform/myguidatamanager.cpp
      ### Patch to disable openxr fetch
        sed -i 's/option(OPENXR_POPULATE "Build openxr support" ON)/option(OPENXR_POPULATE "Build openxr support" OFF)/' extern/CMakeLists.txt
    '' + lib.optionalString stdenv.hostPlatform.isDarwin /* sh */ ''
      ### Don't fix Darwin app bundle
        sed -i '/fixup_bundle/d' CMakeLists.txt
    '';

    nativeBuildInputs = [ cmake git pkg-config wrapQtAppsHook ];

    # If not set, OSG plugin .so files become shell scripts on Darwin.
    dontWrapQtApps = stdenv.hostPlatform.isDarwin;

    buildInputs = [
      SDL2
      boost
      bullet'
      ffmpeg_6
      libXt
      luajit
      lz4
      mygui
      openal
      openscenegraph
      recastnavigation
      unshield
      yaml-cpp
    ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
      CoreMedia
      VideoDecodeAcceleration
      VideoToolbox
    ];

    cmakeFlags = [
      "-DOpenGL_GL_PREFERENCE=${GL}"
      "-DOPENMW_USE_SYSTEM_RECASTNAVIGATION=1"
      "-DOPENXR_SDK_SOURCE=${openxr_sdk}"
      "-DOPENXR_POPULATE=OFF"
    ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "-DOPENMW_OSX_DEPLOYMENT=ON"
    ];

    meta = with lib; {
      description = "Unofficial VR open source engine reimplementation of the game Morrowind";
      homepage = "https://openmw.org";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ abbradar marius851000 ];
      platforms = platforms.linux ++ platforms.darwin;
    };
  }

