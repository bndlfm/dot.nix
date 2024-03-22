{ spicetify-nix, ... }:
let
  system = "x86_64-linux";
  spicePkgs = spicetify-nix.packages.${system}.default;
in {
  programs = {
    spicetify = {
      enable = true;
      theme = spicePkgs.themes.Matte;
      colorScheme = "Matte";
      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        hidePodcasts
      ];
      enabledCustomApps = with spicePkgs.apps; [
        marketplace
      ];
    };
  };
}
