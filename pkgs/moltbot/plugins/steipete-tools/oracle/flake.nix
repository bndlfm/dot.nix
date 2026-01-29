{
  description = "clawdbot plugin: oracle (pure wrapper)";

  inputs.nix-steipete-tools.url =
    "github:clawdbot/nix-steipete-tools?rev=53ead4d5fd722020dddaede861745a32e39d284e&narHash=sha256-lDGYIwZUPXF%2BFoqE9fATn8sqDjfpM7Iy81KhHvqFjyw%3D";

  outputs = { self, nix-steipete-tools }:
    let
      system = builtins.system;
      packagesForSystem = nix-steipete-tools.packages.${system} or {};
      oracle = packagesForSystem.oracle or null;
    in {
      packages.${system} = if oracle == null then {} else { oracle = oracle; };

      clawdbotPlugin = if oracle == null then null else {
        name = "oracle";
        skills = [ "${nix-steipete-tools}/tools/oracle/skills/oracle" ];
        packages = [ oracle ];
        needs = {
          stateDirs = [];
          requiredEnv = [];
        };
      };
    };
}
