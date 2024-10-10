self: super:

{
  obsidian = super.obsidian.overrideAttrs (oldAttrs: {
    postInstall = oldAttrs.postInstall + ''
      wrapProgram "$out/bin/obsidian" \
        --add-flags "--enable-unsafe-gpu"
    '';
  });
}
