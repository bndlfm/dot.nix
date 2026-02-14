{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "waybar-ai-usage";
  version = "0.4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NihilDigit";
    repo = "waybar-ai-usage";
    rev = "v${version}";
    hash = "sha256-svU1NVkpbJ75YyoZjNMMUvWzJJJIJkfewUC2D/eF+mQ=";
  };

  nativeBuildInputs = [
    python3Packages.hatchling
  ];

  propagatedBuildInputs = with python3Packages; [
    browser-cookie3
    curl-cffi
    json5
  ];

  # Upstream declares `json-five` while nixpkgs provides `json5`;
  # runtime check treats this as missing even though functionality is present.
  dontCheckRuntimeDeps = true;

  pythonImportsCheck = [
    "claude"
    "codex"
    "common"
    "waybar_ai_usage"
  ];

  meta = {
    description = "Monitor Claude Code and OpenAI Codex CLI usage via browser cookies";
    homepage = "https://github.com/NihilDigit/waybar-ai-usage";
    license = lib.licenses.mit;
    mainProgram = "waybar-ai-usage";
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
