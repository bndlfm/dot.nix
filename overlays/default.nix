{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    #sunshine = inputs.sunshineFix.legacyPackages.${final.system}.sunshine;
    #aider-chat = inputs.aiderFix.legacyPackages.${final.system}.aider-chat;
    spotify = inputs.oscars-dotfiles.legacyPackages.${final.system}.spotify;
  };

  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  nixpkgs-stable = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  nixpkgs-bndlfm = final: _prev: {
    bndlfm = import inputs.nixpkgs-bndlfm {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
