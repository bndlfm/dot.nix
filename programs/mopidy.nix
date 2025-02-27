{ pkgs, ... }:{
  services.mopidy = let
    mopidyPackagesOverride = pkgs.mopidyPackages.overrideScope (prev: final: {
      extraPkgs = pkgs: [ pkgs.yt-dlp ];
    });
  in {
    extensionPackages = with mopidyPackagesOverride; [
      mopidy-youtube
    ];
    configuration = ''
      [youtube]
      youtube_dl_package = yt_dlp
    '';
  };
}
