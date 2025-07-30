{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    kdePackages.qt5compat
  ];

  programs.quickshell = {
    enable = true;
  };

  home.activation.symlinkQuickshellAndFaceIcon =
    let
      homeDir = builtins.getEnv "HOME";

      faceIconSource = "${homeDir}/.nixcfg/windowManagers/Profile.png";
      faceIconTarget = "${homeDir}/.config/quickshell/mamimi.png";

      quickshellDir = "${homeDir}/.nixcfg/windowManagers/quickshell/qml";
      quickshellTarget = "${homeDir}/.config/quickshell";

    in
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ln -sfn "${quickshellDir}" "${quickshellTarget}"
        ln -sfn "${faceIconSource}" "${faceIconTarget}"
      '';

  #xdg = {
  #    configFile = {
  #        "hypr" = {
  #            source = ./.config/hypr;
  #            recursive = true;
  #        };
  #    };
  #};

}
