{
  description = "clawdbot plugin: camsnap (pure wrapper)";

  inputs.nix-steipete-tools.url =
    "github:clawdbot/nix-steipete-tools?rev=53ead4d5fd722020dddaede861745a32e39d284e&narHash=sha256-lDGYIwZUPXF%2BFoqE9fATn8sqDjfpM7Iy81KhHvqFjyw%3D";

  outputs = { self, nix-steipete-tools }:
    let
      system = builtins.system;
      packagesForSystem = nix-steipete-tools.packages.${system} or {};
      camsnap = packagesForSystem.camsnap or null;
    in {
      packages.${system} = if camsnap == null then {} else { camsnap = camsnap; };

      clawdbotPlugin = if camsnap == null then null else {
        name = "camsnap";
        skills = [ "${nix-steipete-tools}/tools/camsnap/skills/camsnap" ];
        packages = [ camsnap ];
        needs = {
          stateDirs = [];
          requiredEnv = [];
        };
      };
    };
}
