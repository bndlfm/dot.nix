{
self: super: {
  firefox-devedition = super.firefox-devedition.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [
      (super.fetchpatch {
        url = "https://raw.githubusercontent.com/bndlfm/ffMemoryCache/main/ext-tabs.js.patch";
        sha256 = "sha256-Kp21VA4d9RRdP3wwyiu54E4w5b3qbcZBz5YlqAM1Q7I=";
      })
      (super.fetchpatch {
        url = "https://raw.githubusercontent.com/bndlfm/ffMemoryCache/main/tabs.json.patch";
        sha256 = "sha256-jXBmT/LUfwYXT+GKb1cj9g7aIFQDTN24nRceBnwoCOA=";
      })
    ];
  });

  #waybar = super.waybar.overrideAttrs (oldAttrs: {
  #  buildInputs = oldAttrs.buildInputs ++ [ (super.wireplumber.overrideAttrs ) ];
  #});
  }
}
