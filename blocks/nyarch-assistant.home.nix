{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.nyarchassistant;

  # Helper to serialize JSON for GSettings keys that require it
  mkJsonSetting = val: if val != null then builtins.toJSON val else "{}";
  mkJsonListSetting = val: if val != null then builtins.toJSON val else "[]";

in {
  options.programs.nyarchassistant = {
    enable = mkEnableOption "Nyarch Assistant";

    package = mkOption {
      type = types.package;
      default = pkgs.nyarchassistant;
      defaultText = literalExpression "pkgs.nyarchassistant";
      description = "The Nyarch Assistant package to install.";
    };

    # High-level configuration options mapping to GSettings
    config = {
      languageModel = mkOption {
        type = types.str;
        default = "nyarch";
        example = "openai";
        description = "The primary Language Model provider to use.";
      };

      secondaryLanguageModel = mkOption {
        type = types.str;
        default = "newelle";
        description = "The secondary Language Model provider to use.";
      };

      avatarModel = mkOption {
        type = types.enum [ "Live2D" "LivePNG" "vrm" ];
        default = "Live2D";
        description = "The avatar model type to display.";
      };

      ttsEngine = mkOption {
        type = types.str;
        default = "edge_tts";
        description = "The Text-to-Speech engine to use.";
      };

      sttEngine = mkOption {
        type = types.str;
        default = "google_sr";
        description = "The Speech-to-Text engine to use.";
      };
    };

    # Complex settings that need JSON serialization
    settings = {
      llm = mkOption {
        type = types.attrs;
        default = {};
        example = literalExpression ''
          {
            openai = {
              api_key = "sk-....";
              model = "gpt-4o";
            };
          }
        '';
        description = "Configuration for LLM providers. Will be serialized to JSON for `llm-settings`.";
      };

      extensions = mkOption {
        type = types.attrs;
        default = {};
        description = "Configuration for extensions. Will be serialized to JSON for `extensions-settings`.";
      };

      mcpServers = mkOption {
        type = types.listOf types.attrs;
        default = [];
        description = "List of MCP servers. Will be serialized to JSON for `mcp-servers`.";
      };

      tools = mkOption {
        type = types.attrs;
        default = {};
        description = "Configuration for tools. Will be serialized to JSON for `tools-settings`.";
      };
      
      prompts = mkOption {
        type = types.attrs;
        default = {};
        description = "Custom prompts configuration. Will be serialized to JSON for `custom-prompts`.";
      };
    };

    # Escape hatch for other GSettings
    extraDconfSettings = mkOption {
      type = types.attrs;
      default = {};
      description = "Additional GSettings to apply to `moe.nyarchlinux.assistant`.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    dconf.settings."moe/nyarchlinux/assistant" = {
      # Basic strings
      "language-model" = cfg.config.languageModel;
      "secondary-language-model" = cfg.config.secondaryLanguageModel;
      "avatar-model" = cfg.config.avatarModel;
      "tts" = cfg.config.ttsEngine;
      "stt-engine" = cfg.config.sttEngine;

      # JSON-serialized settings
      "llm-settings" = mkJsonSetting cfg.settings.llm;
      "extensions-settings" = mkJsonSetting cfg.settings.extensions;
      "mcp-servers" = mkJsonListSetting cfg.settings.mcpServers;
      "tools-settings" = mkJsonSetting cfg.settings.tools;
      "custom-prompts" = mkJsonSetting cfg.settings.prompts;

      # Defaults for booleans if not overridden in extraDconfSettings
      "virtualization" = true;
      "basic-functionality" = true;
    } // cfg.extraDconfSettings;
  };
}
