{ inputs, ... }:{
  programs.spicetify =
    let
      system = "x86_64-linux";
      spicePkgs = inputs.spicetify-nix.legacyPackages.${system};
    in {
      enable = false;
      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        hidePodcasts
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "Dribblish-dynamic";
      enabledCustomApps = with spicePkgs.apps; [
        marketplace
      ];
    };
}
