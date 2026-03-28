{ pkgs, lib, config, ... }@args:

let
  # FILES
  cfgNushell = callImport ./nushell.home.nix; # The "Override" shell
  cfgFish = callImport ./fish.home.nix;    # The "Base" shell
  cfgKitty = callImport ./kitty.home.nix; # The standard file

  # Helper to import files (handles both raw sets and module functions)
  callImport = file:
    let
      imported = import file;
    in
      if lib.isFunction imported then imported args else imported;


  # Define the custom recursive merge logic (for A and B)
  mergeRecursive = path: v1: v2:
    if (lib.isAttrs v1) && (lib.isAttrs v2) then
      customMerge v1 v2
    else if (lib.isBool v1) && (lib.isBool v2) then
      v1 || v2 # The "OR" Logic
    else
      v2; # Default clobber behavior

  customMerge = s1: s2:
    let
      allKeys = lib.unique ((lib.attrNames s1) ++ (lib.attrNames s2));
    in
      lib.genAttrs allKeys (key:
        let
          v1 = s1.${key} or null;
          v2 = s2.${key} or null;
        in
          if v1 == null then v2
          else if v2 == null then v1
          else mergeRecursive [key] v1 v2
      );

  # 4. Create the special merged result for Shells
  cfgShellMerge = customMerge cfgFish cfgNushell;

in
  # 5. Return a standard module merge
  #    This tells Nix: "Take the result of my custom merge AND the kitty config,
  #    and merge them together using standard system rules."
  lib.mkMerge [
    cfgShellMerge
    cfgKitty
  ]
