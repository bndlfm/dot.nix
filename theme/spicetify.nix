{ spicetify-nix, ... }:{
  programs.spicetify =
    let
      system = "x86_64-linux";
      spicePkgs = spicetify-nix.legacyPackages.${system};
    in {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        hidePodcasts
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "macchiato";
      enabledCustomApps = with spicePkgs.apps; [
        marketplace
      ];
    };
}
