{ pkgs, ... }: {
  programs.claude-desktop = {
    enable = true;
    fhs = true; # FHS wrapper (default: true)
    createDesktopEntry = true; # XDG desktop entry (default: true)
    claudeCodePackage = pkgs.claude-code;
  };
}
