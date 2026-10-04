{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions =
    final: _prev:
    import ../pkgs {
      pkgs = final.pkgs;
      wnv-src = inputs.waydroid-nvidia-src;
    };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications =
    final: prev:
    let
      pondSource = builtins.fetchGit {
        url = "https://github.com/bndlfm/pond.fish.git";
        ref = "refs/heads/feat/pond-3-acp-rewrite";
        rev = "7917f58d92ea10eec94fffefd946aba5c7a6b068";
      };
      kwinVrSource = final.fetchFromGitLab {
        domain = "invent.kde.org";
        owner = "plasma";
        repo = "kwin";
        rev = "ccdd46eadbd705c6ea2efb9c5de03e2fe5ec148a";
        hash = "sha256-hZgCzEp+vyE3zMVDj5ON2XJSbQP9U0g/1AVK3ASrjsg=";
      };
    in
    {
      ### FIXES
      hyprland = inputs.hyprland.packages.${prev.system}.hyprland;
      ucx = prev.ucx.override { enableCuda = false; };
      kdePackages = prev.kdePackages // {
        kwin = prev.kdePackages.kwin.overrideAttrs (old: {
          version = "6.7.5-vr-mr8671";
          src = kwinVrSource;
          patches = (old.patches or [ ]) ++ [
            ../patches/kwin-include-qqml.h.patch
            (final.writeText "kwin-vr-binding.patch" ''
              diff --git a/src/plugins/vr/qml/VrWindowManipulation.qml b/src/plugins/vr/qml/VrWindowManipulation.qml
              --- a/src/plugins/vr/qml/VrWindowManipulation.qml
              +++ b/src/plugins/vr/qml/VrWindowManipulation.qml
              @@ -53,5 +53,7 @@ QtObject {
                   // Attach/detach constraint to pointer handler
                   readonly property Binding constraintBinding: Binding {
              -        root.pointerHandler.constraint: root.barrierConstraint
              +        target: root.pointerHandler
              +        property: "constraint"
              +        value: root.barrierConstraint
                       when: root.barrierEnabled
                   }
              diff --git a/src/plugins/vr/qml/VrRayController.qml b/src/plugins/vr/qml/VrRayController.qml
              --- a/src/plugins/vr/qml/VrRayController.qml
              +++ b/src/plugins/vr/qml/VrRayController.qml
              @@ -29,10 +29,22 @@ QtObject {
                   // Ray visibility
                   readonly property bool rayVisible: root.xray.enabled && root.xray.currentColor.a > 0
              
              -    readonly property Binding vrRayBinding: Binding {
              -        root.xray.vrRay.length: root.rayLength
              -        root.xray.vrRay.baseColor: root.xray.currentColor
              -        root.xray.vrRay.visible: root.rayVisible
              -        when: root.xray.vrRay
              -    }
              +    readonly property Binding vrRayLengthBinding: Binding {
              +        target: root.xray.vrRay
              +        property: "length"
              +        value: root.rayLength
              +        when: root.xray.vrRay
              +    }
              +    readonly property Binding vrRayColorBinding: Binding {
              +        target: root.xray.vrRay
              +        property: "baseColor"
              +        value: root.xray.currentColor
              +        when: root.xray.vrRay
              +    }
              +    readonly property Binding vrRayVisibleBinding: Binding {
              +        target: root.xray.vrRay
              +        property: "visible"
              +        value: root.rayVisible
              +        when: root.xray.vrRay
              +    }
               }
              diff --git a/src/plugins/vr/qml/VrCursorManager.qml b/src/plugins/vr/qml/VrCursorManager.qml
              --- a/src/plugins/vr/qml/VrCursorManager.qml
              +++ b/src/plugins/vr/qml/VrCursorManager.qml
              @@ -23,22 +23,44 @@ QtObject {
                   // TODO: need to convert this to StateGroup instead of these two bindings
              -    readonly property Binding movingResizingCursorBinding: Binding {
              -        root.cursor3d.rotation: root.currentMovingResizingWindow?.sceneRotation ?? Qt.quaternion(1,0,0,0)
              -        root.cursor3d.position: {
              -            if(!root.pointerHandler.lastIntersection.valid || !root.currentMovingResizingWindow) {
              -                return Qt.vector3d(0,0,0)
              -            } else {
              -                const normal = root.currentMovingResizingWindow.mapDirectionToScene(Qt.vector3d(0,0,1))
              -                return root.cursor3d.calcHoveredPosition(root.pointerHandler.lastIntersection.position, normal)
              -            }
              -        }
              -        root.cursor3d.visible: root.cursorEnabled && root.pointerHandler.lastIntersection.valid && !!root.currentMovingResizingWindow
              -        when: root.currentMovingResizingWindow
              -    }
              -
              -    readonly property Binding hoveringCursorBinding: Binding {
              -        root.cursor3d.rotation: root.picking.hoveredObject?.sceneRotation ?? Qt.quaternion(1,0,0,0)
              -        root.cursor3d.position: root.cursor3d.calcHoveredPosition(root.picking.lastPick.scenePosition, root.picking.lastPick.sceneNormal)
              -        root.cursor3d.visible: root.cursorEnabled && !!root.picking.hoveredObject
              -        when: root.picking.hoveredObject && !root.currentMovingResizingWindow && root.xray.enabled
              -    }
              +    readonly property Binding movingRotationBinding: Binding {
              +        target: root.cursor3d
              +        property: "rotation"
              +        value: root.currentMovingResizingWindow?.sceneRotation ?? Qt.quaternion(1,0,0,0)
              +        when: root.currentMovingResizingWindow
              +    }
              +    readonly property Binding movingPositionBinding: Binding {
              +        target: root.cursor3d
              +        property: "position"
              +        value: {
              +            if (!root.pointerHandler.lastIntersection.valid || !root.currentMovingResizingWindow) {
              +                return Qt.vector3d(0, 0, 0)
              +            }
              +            const normal = root.currentMovingResizingWindow.mapDirectionToScene(Qt.vector3d(0, 0, 1))
              +            return root.cursor3d.calcHoveredPosition(root.pointerHandler.lastIntersection.position, normal)
              +        }
              +        when: root.currentMovingResizingWindow
              +    }
              +    readonly property Binding movingVisibleBinding: Binding {
              +        target: root.cursor3d
              +        property: "visible"
              +        value: root.cursorEnabled && root.pointerHandler.lastIntersection.valid && !!root.currentMovingResizingWindow
              +        when: root.currentMovingResizingWindow
              +    }
              +    readonly property Binding hoveringRotationBinding: Binding {
              +        target: root.cursor3d
              +        property: "rotation"
              +        value: root.picking.hoveredObject?.sceneRotation ?? Qt.quaternion(1, 0, 0, 0)
              +        when: root.picking.hoveredObject && !root.currentMovingResizingWindow && root.xray.enabled
              +    }
              +    readonly property Binding hoveringPositionBinding: Binding {
              +        target: root.cursor3d
              +        property: "position"
              +        value: root.cursor3d.calcHoveredPosition(root.picking.lastPick.scenePosition, root.picking.lastPick.sceneNormal)
              +        when: root.picking.hoveredObject && !root.currentMovingResizingWindow && root.xray.enabled
              +    }
              +    readonly property Binding hoveringVisibleBinding: Binding {
              +        target: root.cursor3d
              +        property: "visible"
              +        value: root.cursorEnabled && !!root.picking.hoveredObject
              +        when: root.picking.hoveredObject && !root.currentMovingResizingWindow && root.xray.enabled
              +    }
               }
              diff --git a/src/plugins/vr/qml/VrPointerHandler.qml b/src/plugins/vr/qml/VrPointerHandler.qml
              --- a/src/plugins/vr/qml/VrPointerHandler.qml
              +++ b/src/plugins/vr/qml/VrPointerHandler.qml
              @@ -129,6 +129,8 @@ QtObject {
                   }
               
                   readonly property Binding rayInputVRWindowBinding: Binding {
              -        bridge3d.pointerPosition: Qt.point(root.picking.lastPick.uvPosition.x, root.picking.lastPick.uvPosition.y)
              +        target: bridge3d
              +        property: "pointerPosition"
              +        value: Qt.point(root.picking.lastPick.uvPosition.x, root.picking.lastPick.uvPosition.y)
                       when: root.currentHoveredVRWindow && !root.currentMovingResizingWindow && !root.xray.grabbedObject
                   }
              diff --git a/src/plugins/vr/qml/KwinDecoratedSurfacedWindow3D.qml b/src/plugins/vr/qml/KwinDecoratedSurfacedWindow3D.qml
              --- a/src/plugins/vr/qml/KwinDecoratedSurfacedWindow3D.qml
              +++ b/src/plugins/vr/qml/KwinDecoratedSurfacedWindow3D.qml
              @@ -74,5 +74,7 @@ QtObject {
                       /* Copy internal or surfaced window depth (decorations have no depth currently) */
                       Binding {
              -            root.itemDepth: winLoader.item.itemDepth
              +            target: root
              +            property: "itemDepth"
              +            value: winLoader.item.itemDepth
                           when: winLoader.item
                       }
              diff --git a/src/plugins/vr/qml/XrScene.qml b/src/plugins/vr/qml/XrScene.qml
              --- a/src/plugins/vr/qml/XrScene.qml
              +++ b/src/plugins/vr/qml/XrScene.qml
              @@ -205,4 +205,6 @@ Loader3D {
               
                           Binding {
              -                pickRay.enabled: true
              +                target: pickRay
              +                property: "enabled"
              +                value: true
                           }
            '')
            (final.writeText "kwin-require-quick3dxr.patch" ''
              diff --git a/CMakeLists.txt b/CMakeLists.txt
              --- a/CMakeLists.txt
              +++ b/CMakeLists.txt
              @@ -404,2 +404,4 @@ set(QT_USE_BUNDLED_BundledOpenXR OFF CACHE BOOL "Use system OpenXR")
              +list(APPEND CMAKE_MODULE_PATH "''${Qt6Quick3DXr_DIR}/../Qt6")
               find_package(Qt6 ''${QT_MIN_VERSION} CONFIG QUIET COMPONENTS Quick3DXr)
              +find_package(Qt6Quick3DXr ''${QT_MIN_VERSION} CONFIG REQUIRED)
               cmake_dependent_option(KWIN_BUILD_VR "Enable building of KWin with VR support" ON "Qt6Quick3DXr_FOUND" OFF)
            '')
          ];
          buildInputs = (old.buildInputs or [ ]) ++ [
            final.qt6.qtdeclarative
            final.qt6.qtshadertools
            final.qt6.qtquick3d
            final.openxr-loader
          ];
          qtWrapperArgs = (old.qtWrapperArgs or [ ]) ++ [
            "--prefix LD_LIBRARY_PATH : ${final.openxr-loader}/lib"
          ];
          cmakeFlags = (old.cmakeFlags or [ ]) ++ [
            "-DKWIN_BUILD_VR=ON"
            "-DQt6Quick3DXr_DIR=${final.qt6.qtquick3d}/lib/cmake/Qt6Quick3DXr"
            "-DQt6BundledOpenXR_DIR=${final.qt6.qtquick3d}/lib/cmake/Qt6BundledOpenXR"
            "-DQT_BUILD_CMAKE_PREFIX_PATH=${final.qt6.qtquick3d};${final.qt6.qtshadertools};${final.qt6.qtdeclarative};${final.qt6.qtbase};${final.openxr-loader.dev}"
            "-DQT_DISABLE_NO_DEFAULT_PATH_IN_QT_PACKAGES=ON"
            "-DOpenXR_DIR=${final.openxr-loader.dev}/lib/cmake/openxr"
          ];
        });
      };
      code-cursor = prev.code-cursor.overrideAttrs (oldAttrs: {
        postBuild = ''
          wrapProgram $out/bin/cursor --set ELECTRON_OZONE_PLATFORM_HINT X11
        '';
      });
      wivrn = prev.wivrn.overrideAttrs (
        old:
        let
          wivrnVersion = "26.9";
          wivrnSource = final.fetchFromGitHub {
            owner = "wivrn";
            repo = "wivrn";
            rev = "v${wivrnVersion}";
            hash = "sha256-/kXgbku/4EeYY5YTwtY71csgxOP8bRACLqOvKXolg5g=";
          };
        in
        {
          version = wivrnVersion;
          src = wivrnSource;
          monado = final.applyPatches {
            src = final.fetchFromGitLab {
              domain = "gitlab.freedesktop.org";
              owner = "monado";
              repo = "monado";
              rev = "f037264d23e2472a444a157370647fcd601ed81b";
              hash = "sha256-exHbecudAy57szL7kut7/fBYCoekEs3riZzhMtFWS/c=";
            };
            postPatch = ''
              ${wivrnSource}/patches/apply.sh ${wivrnSource}/patches/monado/*
            '';
          };
          buildInputs = final.lib.filter (input: input != final.libpulseaudio) old.buildInputs;
          cmakeFlags =
            (final.lib.filter (
              flag:
              !(final.lib.hasPrefix "-DGIT_DESC:" flag)
              && !(final.lib.hasPrefix "-DGIT_COMMIT:" flag)
              && !(final.lib.hasPrefix "-DWIVRN_USE_PULSEAUDIO:" flag)
            ) old.cmakeFlags)
            ++ [
              (final.lib.cmakeFeature "GIT_TAG" "v${wivrnVersion}")
            ];
          postFixup = (old.postFixup or "") + ''
            for bin in wivrnctl wivrn-dashboard wivrn-server; do
              if [ -e $out/bin/$bin ]; then
                wrapProgram $out/bin/$bin \
                  --prefix PATH : ${final.lib.makeBinPath [ final.android-tools ]}
              fi
            done
          '';
        }
      );
      fish = prev.fish.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          "${pondSource}/patches/fish-command-capture.patch"
        ];
      });
    };

  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  nixpkgs-stable = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  nixpkgs-bndlfm = final: _prev: {
    bndlfm = import inputs.nixpkgs-bndlfm {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
