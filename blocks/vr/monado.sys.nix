{ pkgs, ... }:
{
  ### MONADO SERVICE / ENV
  services.monado = {
    enable = true;
    defaultRuntime = true;
    highPriority = true;
  };
  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
  };

  ### HAND TRACKING DATA ###
  programs.git = {
    enable = true;
    lfs.enable = true;
  };
  systemd.services.clone-monado-repo = {
    description = "Ensure Monado repo exists in user home";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "neko";
      Group = "users";
    };
    path = with pkgs; [
      git
      git-lfs
      coreutils
    ];
    script = ''
      TARGET_DIR="/home/neko/.local/share/monado"
      mkdir -p "$TARGET_DIR"

      # Clone Hand Tracking Models only
      cd "$TARGET_DIR"
      if [ ! -d "hand-tracking-models" ]; then
        echo "Cloning Hand Tracking Models..."
        git clone https://gitlab.freedesktop.org/monado/utilities/hand-tracking-models
      else
        echo "Hand Tracking Models already present."
      fi
    '';
  };
}
