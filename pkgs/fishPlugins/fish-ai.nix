{
  lib,
  pkgs,
  stdenv,
  #buildFishPlugin,
  fetchFromGitHub,
  writeScript,
  wrapFish,
}:

  let
    buildFishPlugin = import ./build-fish-plugin.nix {inherit stdenv lib writeScript wrapFish; };
  in
    buildFishPlugin rec {
      pname = "fish-ai";
      version = "1.8.0";

      src =
        fetchFromGitHub
          {
            owner = "Realiserad";
            repo = pname;
            rev = "v1.8.0";
            sha256 = "sha256-SywATcha9xvxr6dwMZqXWfFTydriHAGU3sjkBQYmSg4=";
          };

      runtimeDependencies =
        with pkgs;
          [
            git
            python3
            python3Packages.pip
          ];

      postPatch = # REMOVE HARDCODED ~/.fish-ai/bin SO WE CAN USE NIX STORE
        let
          fishFiles =
            [
              "_fish_ai_autocomplete.fish"
              "_fish_ai_codify.fish"
              "_fish_ai_explain.fish"
              "_fish_ai_fix.fish"
              "fish_ai_switch_context.fish"
            ];
          substituteCommand = file: /*sh*/ ''substituteInPlace functions/${file} --replace-fail "~/.fish-ai/bin" $out/share/fish/vendor_functions.d'';
        in /*sh*/
          ''
            # vendor_functions.d PATCHING
            mkdir -p $out/share/fish/vendor_functions.d
            ${lib.concatStringsSep "\n" (map substituteCommand fishFiles)};

            # conf.d PATCHING
            substituteInPlace conf.d/fish_ai.fish --replace-fail "~/.fish-ai/bin/python3" ${pkgs.python3}
            substituteInPlace conf.d/fish_ai.fish --replace-fail "~/.fish-ai/bin/pip" ${pkgs.python3Packages.pip}
          '';

      postInstall =  #buildFishPlugin DOESN'T COPY PYTHON .py FILES, ONLY .fish
        let
          pyFiles =
            [
              "__init__.py"
              "autocomplete.py"
              "codify.py"
              "config.py"
              "engine.py"
              "explain.py"
              "fix.py"
              "put_api_key.py"
              "redact.py"
              "switch_context.py"
            ];
          copyCommand = file: /*sh*/ ''cp src/fish_ai/${file} $out/share/fish/vendor_functions.d/${file}'';
        in /*sh*/
            ''
              mkdir -p $out/share/fish/vendor_functions.d/
              cp -r src/fish_ai/* $out/share/fish/vendor_functions.d/
              #$#{lib.concatStringsSep "\n" (map copyCommand pyFiles)}
            '';

      meta =
        with lib;
          {
            description = " Supercharge your command line with LLMs and get shell scripting assistance in Fish. 💪";
            homepage = "https://github.com/Realiserad/fish-ai";
            license = licenses.mit;
            maintainers = with maintainers; [ bndlfm ];
          };
    }
