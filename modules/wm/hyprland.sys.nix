{
  inputs,
  pkgs,
  ...
}:{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    withUWSM = true;
    xwayland.enable = true;
  };
  security.pam.services.hyprlock = {
    text = ''
      # Account management
      account required /nix/store/qpvnannhp4mi4gglmpjqclc17x9c0pq3-linux-pam-1.7.2/lib/security/pam_unix.so

      # Authentication management
      auth optional /nix/store/qpvnannhp4mi4gglmpjqclc17x9c0pq3-linux-pam-1.7.2/lib/security/pam_unix.so likeauth nullok
      auth sufficient /nix/store/qpvnannhp4mi4gglmpjqclc17x9c0pq3-linux-pam-1.7.2/lib/security/pam_unix.so likeauth nullok try_first_pass
      auth required /nix/store/qpvnannhp4mi4gglmpjqclc17x9c0pq3-linux-pam-1.7.2/lib/security/pam_deny.so

      # Password management
      password sufficient /nix/store/qpvnannhp4mi4gglmpjqclc17x9c0pq3-linux-pam-1.7.2/lib/security/pam_unix.so nullok

      # Session management
      session required /nix/store/qpvnannhp4mi4gglmpjqclc17x9c0pq3-linux-pam-1.7.2/lib/security/pam_env.so conffile=/etc/pam/environment readenv=0
      session required /nix/store/qpvnannhp4mi4gglmpjqclc17x9c0pq3-linux-pam-1.7.2/lib/security/pam_unix.so
      session required /nix/store/qpvnannhp4mi4gglmpjqclc17x9c0pq3-linux-pam-1.7.2/lib/security/pam_limits.so conf=/nix/store/npilx7hfknmqjir23qi006qd8g670b3z-limits.conf
    '';
  };
  xdg.portal = {
    config.hyprland.default = [ "hyprland" "kde" ];
    extraPortals = with pkgs; [  ];
  };
}
