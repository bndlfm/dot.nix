{ inputs, pkgs, ... }:
{
  programs.domicile = {
    enable = true;

    # Use the tested Manganese shell from the fork until the upstream PR lands.
    shell = "${inputs.domicile.packages.${pkgs.system}.manganese}/shell.js";
  };
}
