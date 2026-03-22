{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.wlr-which-key;
  yamlFormat = pkgs.formats.yaml { };

  menuItemOpts = { ... }: {
    options = {
      key = mkOption {
        type = with types; either str (listOf str);
        description = "Key or list of keys to trigger the action.";
      };
      desc = mkOption {
        type = types.str;
        description = "Description shown in the menu.";
      };
      cmd = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Command to execute.";
      };
      submenu = mkOption {
        type = types.nullOr (types.listOf (types.submodule menuItemOpts));
        default = null;
        description = "Nested submenu items.";
      };
      keep_open = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to keep the UI open after command execution.";
      };
    };
  };

  # Recursive function to clean up menu items
  cleanMenu = items: map (item:
    let
      # Filter out nulls and default false values for keep_open
      cleaned = filterAttrs (n: v: v != null && (n != "keep_open" || v != false)) item;
      # Recursively clean submenus if they exist
      withCleanSubmenu = if cleaned ? submenu then
        cleaned // { submenu = cleanMenu cleaned.submenu; }
      else
        cleaned;
    in
    withCleanSubmenu
  ) items;

in {
  options.programs.wlr-which-key = {
    enable = mkEnableOption "wlr-which-key";

    package = mkPackageOption pkgs "wlr-which-key" { };

    settings = mkOption {
      type = yamlFormat.type;
      default = { };
      example = literalExpression ''
        {
          font = "JetBrainsMono Nerd Font 12";
          background = "#282828d0";
          color = "#fbf1c7";
          anchor = "center";
        }
      '';
      description = ''
        Configuration written to {file}`$XDG_CONFIG_HOME/wlr-which-key/config.yaml`.
        See <https://github.com/MaxVerevkin/wlr-which-key#configuration> for options.
      '';
    };

    menus = mkOption {
      type = types.listOf (types.submodule menuItemOpts);
      default = [ ];
      description = "The root menu structure.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."wlr-which-key/config.yaml".source =
      yamlFormat.generate "wlr-which-key-config" (
        cfg.settings // { menu = cleanMenu cfg.menus; }
      );
  };
}
