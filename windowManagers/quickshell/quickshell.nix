{ config, lib, pkgs, ... }:
{
  home.programs.quickshell = {
    enable = true;
  };
  home.activation.symlinkQuickshellAndFaceIcon =
    let
      homeDir = builtins.getEnv "HOME";

      faceIconSource = "${homeDir}/.nixcfg/windowManager/profile.gif";
      faceIconTarget = "${homeDir}/Pictures/mamimi.png";

      quickshellDir = "${homeDir}/.nixcfg/windowManager/quickshell";
      quickshellTarget = "${homeDir}/.nixcfg/windowManager/quickshell";

    in
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ln -sfn "${quickshellDir}" "${quickshellTarget}"
        ln -sfn "${faceIconSource}" "${faceIconTarget}"
      '';
}
