{pkgs, ... }:
{
  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession = {
      enable = true;
      env = {
        PROTON_ENABLE_NVAPI = "1";
        PROTON_HIDE_NVIDIA_GPU = "0";
        VKD3D_CONFIG = "dxr";
        VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
        MANGO_HUD = "1";
      };
    };
    remotePlay.openFirewall = true;

    extraCompatPackages = with pkgs; [
      (pkgs.callPackage ../pkgs/proton-ge-rtsp.nix {})
      proton-ge-bin
    ];
  };
}
