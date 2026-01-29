{
  description = "clawdbot plugin: sag (pure wrapper)";

  inputs.nix-steipete-tools.url =
    "github:clawdbot/nix-steipete-tools?rev=53ead4d5fd722020dddaede861745a32e39d284e&narHash=sha256-lDGYIwZUPXF%2BFoqE9fATn8sqDjfpM7Iy81KhHvqFjyw%3D";

  outputs = { self, nix-steipete-tools }:
    let
      system = builtins.system;
      packagesForSystem = nix-steipete-tools.packages.${system} or {};
      sag = packagesForSystem.sag or null;
    in {
      packages.${system} = if sag == null then {} else { sag = sag; };

      clawdbotPlugin = if sag == null then null else {
        name = "sag";
        skills = [ "${nix-steipete-tools}/tools/sag/skills/sag" ];
        packages = [ sag ];
        needs = {
          stateDirs = [];
          requiredEnv = [];
        };
      };
    };
}
