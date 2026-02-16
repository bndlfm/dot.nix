{
  pkgs, # Host packages (includes overlays)
  lib,
  ...
}:
let
  # Prefer overlay package, but support direct extra-container evaluation too.
  localPkgs = import ../pkgs pkgs;
  getPkg =
    name:
    if builtins.hasAttr name pkgs
    then builtins.getAttr name pkgs
    else builtins.getAttr name localPkgs;
  openclawPkg = getPkg "_openclaw";
  openclawPluginPkgs = map getPkg [
    "_bird"
    "_blogwatcher"
    "_camsnap"
    "_clawdhub"
    "_gifgrep"
    "_gogcli"
    "_goplaces"
    "_mcporter"
    "_nano-pdf"
    "_songsee"
    "_summarize"
    "_sag"
  ];
in
{
  containers.openclaw = {
    autoStart = true;
    privateNetwork = false; # Share host network for easy internet/mcp access

    bindMounts = {
      # OpenClaw state/config/workspace - RW
      "/root/.openclaw" = {
        hostPath = "/home/neko/.openclaw";
        isReadOnly = false;
      };
      # Notes - Read-Write access to Obsidian vault
      "/root/Notes" = {
        hostPath = "/home/neko/Notes";
        isReadOnly = false;
      };
      # GPU devices for CUDA/NVIDIA workloads
      "/dev/nvidiactl" = {
        hostPath = "/dev/nvidiactl";
        isReadOnly = false;
      };
      "/dev/nvidia0" = {
        hostPath = "/dev/nvidia0";
        isReadOnly = false;
      };
      "/dev/nvidia-uvm" = {
        hostPath = "/dev/nvidia-uvm";
        isReadOnly = false;
      };
      "/dev/nvidia-uvm-tools" = {
        hostPath = "/dev/nvidia-uvm-tools";
        isReadOnly = false;
      };
      "/dev/nvidia-modeset" = {
        hostPath = "/dev/nvidia-modeset";
        isReadOnly = false;
      };
      "/dev/nvidia-caps" = {
        hostPath = "/dev/nvidia-caps";
        isReadOnly = false;
      };
      "/dev/dri" = {
        hostPath = "/dev/dri";
        isReadOnly = false;
      };
    };

    config =
      { pkgs, ... }: # Container packages (no overlays)
      {
        system.stateVersion = "24.11";
        nixpkgs.config.allowUnfree = true;

        systemd.tmpfiles.rules = [
          "d /root/.config 0700 root root -"
          "d /root/.local 0700 root root -"
          "d /root/.local/state 0700 root root -"
        ];

        # Packages available inside
        environment.systemPackages =
          with pkgs;
          [
            git
            # Tools
            curl
            wget
            pciutils
            nvtopPackages.full
            linuxPackages.nvidia_x11
          ]
          ++ [ openclawPkg ]
          ++ openclawPluginPkgs;

        systemd.services.openclaw = {
          description = "OpenClaw Gateway";
          wantedBy = [ "multi-user.target" ];
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          serviceConfig = {
            WorkingDirectory = "/root";
            Environment = [
              "HOME=/root"
              "XDG_CONFIG_HOME=/root/.config"
              "XDG_STATE_HOME=/root/.local/state"
            ];
            ExecStart = "${lib.getExe openclawPkg} gateway start";
            Restart = "always";
            RestartSec = "3s";
          };
        };
      };
  };
}
