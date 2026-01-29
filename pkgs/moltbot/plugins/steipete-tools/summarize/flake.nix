{
  description = "clawdbot plugin: summarize (pure wrapper)";

  inputs.nix-steipete-tools.url =
    "github:clawdbot/nix-steipete-tools?rev=53ead4d5fd722020dddaede861745a32e39d284e&narHash=sha256-lDGYIwZUPXF%2BFoqE9fATn8sqDjfpM7Iy81KhHvqFjyw%3D";

  outputs = { self, nix-steipete-tools }:
    let
      system = builtins.system;
      packagesForSystem = nix-steipete-tools.packages.${system} or {};
      summarize = packagesForSystem.summarize or null;
    in {
      packages.${system} = if summarize == null then {} else { summarize = summarize; };

      clawdbotPlugin = if summarize == null then null else {
        name = "summarize";
        skills = [ "${nix-steipete-tools}/tools/summarize/skills/summarize" ];
        packages = [ summarize ];
        needs = {
          stateDirs = [];
          requiredEnv = [];
        };
      };
    };
}
