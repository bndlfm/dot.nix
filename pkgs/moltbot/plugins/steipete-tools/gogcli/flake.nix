{
  description = "clawdbot plugin: gogcli (pure wrapper)";

  inputs.nix-steipete-tools.url =
    "github:clawdbot/nix-steipete-tools?rev=53ead4d5fd722020dddaede861745a32e39d284e&narHash=sha256-lDGYIwZUPXF%2BFoqE9fATn8sqDjfpM7Iy81KhHvqFjyw%3D";

  outputs = { self, nix-steipete-tools }:
    let
      system = builtins.system;
      packagesForSystem = nix-steipete-tools.packages.${system} or {};
      gogcli = packagesForSystem.gogcli or null;
    in {
      packages.${system} = if gogcli == null then {} else { gogcli = gogcli; };

      clawdbotPlugin = if gogcli == null then null else {
        name = "gogcli";
        skills = [ "${nix-steipete-tools}/tools/gogcli/skills/gogcli" ];
        packages = [ gogcli ];
        needs = {
          stateDirs = [];
          requiredEnv = [];
        };
      };
    };
}
