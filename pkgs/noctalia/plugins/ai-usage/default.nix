{
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "noctalia-plugin-ai-usage";
  version = "0.1.0";

  src = ./plugin;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/noctalia-shell/plugins/ai-usage"
    cp -r ./* "$out/share/noctalia-shell/plugins/ai-usage/"
    runHook postInstall
  '';

  meta = {
    description = "Noctalia plugin that shows AI usage in the bar";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
