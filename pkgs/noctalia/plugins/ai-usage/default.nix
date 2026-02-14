{
  waybarAiUsage,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "noctalia-plugin-ai-usage";
  version = "0.1.0";

  src = ./plugin;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    mkdir -p "$out/share/noctalia-shell/plugins/ai-usage"
    cp -r ./* "$out/share/noctalia-shell/plugins/ai-usage/"
    install -m755 ./ai-usage "$out/bin/ai-usage"
    sed -i "s|__AI_USAGE_CMD__|$out/bin/ai-usage|g" "$out/share/noctalia-shell/plugins/ai-usage/manifest.json"
    sed -i "s|__CLAUDE_USAGE_BIN__|${waybarAiUsage}/bin/claude-usage|g" "$out/share/noctalia-shell/plugins/ai-usage/ai-usage"
    sed -i "s|__CODEX_USAGE_BIN__|${waybarAiUsage}/bin/codex-usage|g" "$out/share/noctalia-shell/plugins/ai-usage/ai-usage"
    runHook postInstall
  '';

  meta = {
    description = "Noctalia plugin that shows AI usage in the bar";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
