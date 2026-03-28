{ pkgs, ... }:{
  programs = {
    /***********
    * NU SHELL *
    ***********/
    nushell = {
      enable = false;
      envFile.text = /*sh*/ ''
        # Disable the annoying banner
        $env.config.show_banner = false

        ### VI KEYS ###
        $env.config.edit_mode = "vi"
        $env.config.keybindings = [
          { # HJKL => HNEI
              name: colemak_move_left
              modifier: none
              keycode: 'char_h'
              mode: [ vi_normal ]
              event: { edit: MoveLeft }
          }
          {
              name: colemak_move_down
              modifier: none
              keycode: 'char_n'
              mode: [ vi_normal ]
              event: { send: Down }
          }
          {
              name: colemak_move_up
              modifier: none
              keycode: 'char_e'
              mode: [ vi_normal ]
              event: { send: Up }
          }
          {
              name: colemak_move_right
              modifier: none
              keycode: char_i
              mode: [ vi_normal ]
              event: { edit: MoveRight }
          }
          # K = Insert Mode
          {
            name: colemak_insert_mode
            modifier: none
            keycode: char_k
            mode: [ vi_normal ]
            event: { send: ViChangeMode, mode: insert }
          }
          {
            name: list_dir
            modifier: Alt
            keycode: char_d
            mode: [ vi_normal vi_insert ]
            event: {
              send: ExecuteHostCommand,
              cmd: "print 'ls -la|where type==dir'; ls -la | where type == dir"
            }
          }
          {
            name: list_files
            modifier: Alt
            keycode: char_l
            mode: [ vi_normal vi_insert ]
            event: {
              send: ExecuteHostCommand,
              cmd: "print 'ls -la'; ls -la"
            }
          }
        ]
        $env.config.cursor_shape = {
          vi_insert: line
          vi_normal: block
        }
        $env.config.use_kitty_protocol = true
        $env.config.shell_integration.osc2 = true
        $env.config.shell_integration.osc7 = ($nu.os-info.name != windows)
        $env.config.shell_integration.osc9_9 = ($nu.os-info.name == windows)
        $env.config.shell_integration.osc8 = true
      '';
      configFile.text = /* sh */''
        def lsg [] {
          ls | sort-by {|r|
            if $r.type == dir or ($r.type == symlink and ($r.name | path expand | path type) == dir) { 
              0
            } else {
              1
            }
          } name -i | grid -c --icons
        }


        ### SHELL GREETING ###
        bat ~/Notes/To-do/To-do.md --style=plain --no-paging
      '';
      plugins = with pkgs.nushellPlugins; [
        skim
        gstat
        query
      ];
    };
  /*********************
  * SHELL INTEGRATIONS *
  *********************/
    broot = {
      enable = true;
      enableNushellIntegration = true;
    };
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
    nix-your-shell = {
      enable = true;
      enableNushellIntegration = true;
    };
    oh-my-posh = {
      enable = false;
      useTheme = "clean-detailed";
      enableNushellIntegration = false;
    };
    pay-respects = {
      enable = true;
      enableNushellIntegration = true;
    };
    yazi = {
      enable = true;
      enableNushellIntegration = true;
    };
    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };
  };

  services = {
    gpg-agent = {
      enableNushellIntegration = true;
    };
  };
}
