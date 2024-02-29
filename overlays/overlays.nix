      # Overlay 1: Use `self` and `super` to express the inheritance relationship
         #(self: super: {
         #  google-chrome = super.google-chrome.override {
         #    commandLineArgs =
         #      "--proxy-server='https=127.0.0.1:3128;http=127.0.0.1:3128'";
         #  };
         #})

self: super: {
  #firefox-devedition = super.firefox-devedition.overrideAttrs (oldAttrs: {
    #patches = oldAttrs.patches ++ [
    #  (super.fetchpatch {
    #    url = "https://raw.githubusercontent.com/bndlfm/ffMemoryCache/main/ext-tabs.js.patch";
    #    sha256 = "sha256-Kp21VA4d9RRdP3wwyiu54E4w5b3qbcZBz5YlqAM1Q7I=";
    #  })
    #  (super.fetchpatch {
    #    url = "https://raw.githubusercontent.com/bndlfm/ffMemoryCache/main/tabs.json.patch";
    #    sha256 = "sha256-jXBmT/LUfwYXT+GKb1cj9g7aIFQDTN24nRceBnwoCOA=";
    #  })
    #];
  #});

  discord = super.discord.overrideAttrs (oldAttrs: {
    args = oldAttrs.args ++ [ "--enable-features=UseOzonePlatform" "--ozone-platform=wayland" ];
    }
  );

  obsidian = super.obsidian.overrideAttrs (oldAttrs: {
    args = oldAttrs.args ++ [ "--enable-features=UseOzonePlatform" "--ozone-platform=wayland" ];
    }
  );
}

