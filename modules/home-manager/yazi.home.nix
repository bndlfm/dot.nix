{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
    settings = {
      manager = {
        ratio = [ 1 4 3 ];
        sort_by = "alphabetical";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = false;
        linemode = "none";
        show_hidden = false;
        show_symlink = true;
        scrolloff = 5;
      };
      preview = {
        tab_size = 2;
        max_width = 600;
        max_height = 900;
        cache_dir = "";
        image_filter = "triangle";
        image_quality = 75;
        sixel_fraction = 15;
        ueberzug_scale = 1;
        ueberzug_offset = [ 0 0 0 0 ];
      };
      opener = {
        edit = [
          { run = ''''${EDITOR:=vi} "$@"''; desc = "$EDITOR"; block = true; "for" = "unix"; }
          { run = ''code "%*"''; orphan = true; "for" = "windows"; }
        ];
        open = [
          { run = ''xdg-open "$@"''; desc = "Open"; "for" = "linux"; }
          { run = ''open "$@"''; desc = "Open"; "for" = "macos"; }
          { run = ''start "" "%1"''; orphan = true; desc = "Open"; "for" = "windows"; }
        ];
        reveal = [
          { run = ''open -R "$1"''; desc = "Reveal"; "for" = "macos"; }
          { run = ''explorer /select, "%1"''; orphan = true; "for" = "windows"; }
          { run = ''exiftool "$1"; echo "Press enter to exit"; read''; block = true; desc = "Show EXIF"; "for" = "unix"; }
        ];
        extract = [
          { run = ''unar "$1"''; desc = "Extract here"; "for" = "unix"; }
          { run = ''unar "%1"''; desc = "Extract here"; "for" = "windows"; }
        ];
        play = [
          { run = ''mpv "$@"''; orphan = true; "for" = "unix"; }
          { run = ''mpv "%1"''; orphan = true; "for" = "windows"; }
          { run = ''mediainfo "$1"; echo "Press enter to exit"; read''; block = true; desc = "Show media info"; "for" = "unix"; }
        ];
      };
      open = {
        rules = [
          { url = "*/"; use = [ "edit" "open" "reveal" ]; }
          { mime = "text/*"; use = [ "edit" "reveal" ]; }
          { mime = "image/*"; use = [ "open" "reveal" ]; }
          { mime = "video/*"; use = [ "play" "reveal" ]; }
          { mime = "audio/*"; use = [ "play" "reveal" ]; }
          { mime = "inode/x-empty"; use = [ "edit" "reveal" ]; }
          { mime = "application/json"; use = [ "edit" "reveal" ]; }
          { mime = "*/javascript"; use = [ "edit" "reveal" ]; }
          { mime = "application/zip"; use = [ "extract" "reveal" ]; }
          { mime = "application/gzip"; use = [ "extract" "reveal" ]; }
          { mime = "application/x-tar"; use = [ "extract" "reveal" ]; }
          { mime = "application/x-bzip"; use = [ "extract" "reveal" ]; }
          { mime = "application/x-bzip2"; use = [ "extract" "reveal" ]; }
          { mime = "application/x-7z-compressed"; use = [ "extract" "reveal" ]; }
          { mime = "application/x-rar"; use = [ "extract" "reveal" ]; }
          { mime = "application/xz"; use = [ "extract" "reveal" ]; }
          { mime = "*"; use = [ "open" "reveal" ]; }
        ];
      };
      tasks = {
        micro_workers = 10;
        macro_workers = 25;
        bizarre_retry = 5;
        image_alloc = 536870912;
        image_bound = [ 0 0 ];
        suppress_preload = false;
      };
      plugin = {
        preloaders = [
          { url = "*"; cond = "!mime"; run = "mime"; multi = true; prio = "high"; }
          { mime = "image/vnd.djvu"; run = "noop"; }
          { mime = "image/*"; run = "image"; }
          { mime = "video/*"; run = "video"; }
          { mime = "application/pdf"; run = "pdf"; }
        ];
        previewers = [
          { url = "*/"; run = "folder"; sync = true; }
          { mime = "text/*"; run = "code"; }
          { mime = "*/xml"; run = "code"; }
          { mime = "*/javascript"; run = "code"; }
          { mime = "*/x-wine-extension-ini"; run = "code"; }
          { mime = "application/json"; run = "json"; }
          { mime = "image/vnd.djvu"; run = "noop"; }
          { mime = "image/*"; run = "image"; }
          { mime = "video/*"; run = "video"; }
          { mime = "application/pdf"; run = "pdf"; }
          { mime = "application/zip"; run = "archive"; }
          { mime = "application/gzip"; run = "archive"; }
          { mime = "application/x-tar"; run = "archive"; }
          { mime = "application/x-bzip"; run = "archive"; }
          { mime = "application/x-bzip2"; run = "archive"; }
          { mime = "application/x-7z-compressed"; run = "archive"; }
          { mime = "application/x-rar"; run = "archive"; }
          { mime = "application/xz"; run = "archive"; }
          { url = "*"; run = "file"; }
        ];
      };
      input = {
        cd_title = "Change directory:";
        cd_origin = "top-center";
        cd_offset = [ 0 2 50 3 ];
        create_title = [ "Create file:" "Create directory:" ];
        create_origin = "top-center";
        create_offset = [ 0 2 50 3 ];
        rename_title = "Rename:";
        rename_origin = "hovered";
        rename_offset = [ 0 1 50 3 ];
        trash_title = "Move {n} selected file{s} to trash? (y/N)";
        trash_origin = "top-center";
        trash_offset = [ 0 2 50 3 ];
        delete_title = "Delete {n} selected file{s} permanently? (y/N)";
        delete_origin = "top-center";
        delete_offset = [ 0 2 50 3 ];
        filter_title = "Filter:";
        filter_origin = "top-center";
        filter_offset = [ 0 2 50 3 ];
        find_title = [ "Find next:" "Find previous:" ];
        find_origin = "top-center";
        find_offset = [ 0 2 50 3 ];
        search_title = "Search via {n}:";
        search_origin = "top-center";
        search_offset = [ 0 2 50 3 ];
        shell_title = [ "Shell:" "Shell (block):" ];
        shell_origin = "top-center";
        shell_offset = [ 0 2 50 3 ];
        overwrite_title = "Overwrite an existing file? (y/N)";
        overwrite_origin = "top-center";
        overwrite_offset = [ 0 2 50 3 ];
        quit_title = "{n} task{s} running, sure to quit? (y/N)";
        quit_origin = "top-center";
        quit_offset = [ 0 2 50 3 ];
      };
      select = {
        open_title = "Open with:";
        open_origin = "hovered";
        open_offset = [ 0 1 50 7 ];
      };
      which = {
        sort_by = "none";
        sort_sensitive = false;
        sort_reverse = false;
      };
      log = {
        enabled = false;
      };
    };
    keymap = {
      mgr.keymap = [
        {
          on = [ "<Esc>" ];
          run = "escape";
          desc = "Exit visual mode, clear selected, or cancel search";
        }
        {
          on = [ "q" ];
          run = "quit";
          desc = "Exit the process";
        }
        {
          on = [ "Q" ];
          run = "quit --no-cwd-file";
          desc = "Exit the process without writing cwd-file";
        }
        {
          on = [ "<C-q>" ];
          run = "close";
          desc = "Close the current tab, or quit if it is last tab";
        }
        {
          on = [ "<C-z>" ];
          run = "suspend";
          desc = "Suspend the process";
        }

        # NAVIGATION
        {
          on = [ "e" ];
          run = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = [ "n" ];
          run = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = [ "E" ];
          run = "arrow -5";
          desc = "Move cursor up 5 lines";
        }
        {
          on = [ "N" ];
          run = "arrow 5";
          desc = "Move cursor down 5 lines";
        }
        {
          on = [ "h" ];
          run = [
            "leave"
            "escape --visual --select"
          ];
          desc = "Go back to the parent directory";
        }
        {
          on = [ "i" ];
          run = [
            "enter"
            "escape --visual --select"
          ];
          desc = "Enter the child directory";
        }
        {
          on = [ "H" ];
          run = "back";
          desc = "Go back to the previous directory";
        }
        {
          on = [ "I" ];
          run = "forward";
          desc = "Go forward to the next directory";
        }
        {
          on = [ "<S-Up>" ];
          run = "arrow -5";
          desc = "Move cursor up 5 lines";
        }
        {
          on = [ "<S-Down>" ];
          run = "arrow 5";
          desc = "Move cursor down 5 lines";
        }

        {
          on = [ "<C-u>" ];
          run = "arrow -50%";
          desc = "Move cursor up half page";
        }
        {
          on = [ "<C-d>" ];
          run = "arrow 50%";
          desc = "Move cursor down half page";
        }
        {
          on = [ "<C-b>" ];
          run = "arrow -100%";
          desc = "Move cursor up one page";
        }
        {
          on = [ "<C-f>" ];
          run = "arrow 100%";
          desc = "Move cursor down one page";
        }

        {
          on = [ "<C-PageUp>" ];
          run = "arrow -50%";
          desc = "Move cursor up half page";
        }
        {
          on = [ "<C-PageDown>" ];
          run = "arrow 50%";
          desc = "Move cursor down half page";
        }
        {
          on = [ "<PageUp>" ];
          run = "arrow -100%";
          desc = "Move cursor up one page";
        }
        {
          on = [ "<PageDown>" ];
          run = "arrow 100%";
          desc = "Move cursor down one page";
        }

        # PREVIEW
        {
          on = [ "<A-e>" ];
          run = "seek -5";
          desc = "Seek up 5 units in the preview";
        }
        {
          on = [ "<A-n>" ];
          run = "seek 5";
          desc = "Seek down 5 units in the preview";
        }
        {
          on = [ "<A-PageUp>" ];
          run = "seek -5";
          desc = "Seek up 5 units in the preview";
        }
        {
          on = [ "<A-PageDown>" ];
          run = "seek 5";
          desc = "Seek down 5 units in the preview";
        }

        {
          on = [ "<Up>" ];
          run = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = [ "<Down>" ];
          run = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = [ "<Left>" ];
          run = "leave";
          desc = "Go back to the parent directory";
        }
        {
          on = [ "<Right>" ];
          run = "enter";
          desc = "Enter the child directory";
        }

        {
          on = [
            "g"
            "g"
          ];
          run = "arrow -99999999";
          desc = "Move cursor to the top";
        }
        {
          on = [ "G" ];
          run = "arrow 99999999";
          desc = "Move cursor to the bottom";
        }

        # Selection
        {
          on = [ "<Space>" ];
          run = [
            "select --state=none"
            "arrow 1"
          ];
          desc = "Toggle the current selection state";
        }
        {
          on = [ "v" ];
          run = "visual_mode";
          desc = "Enter visual mode (selection mode)";
        }
        {
          on = [ "V" ];
          run = "visual_mode --unset";
          desc = "Enter visual mode (unset mode)";
        }
        {
          on = [ "<C-a>" ];
          run = "select_all --state=true";
          desc = "Select all files";
        }
        {
          on = [ "<C-r>" ];
          run = "select_all --state=none";
          desc = "Inverse selection of all files";
        }

        # Operation
        {
          on = [ "o" ];
          run = "open";
          desc = "Open the selected files";
        }
        {
          on = [ "O" ];
          run = "open --interactive";
          desc = "Open the selected files interactively";
        }
        {
          on = [ "<Enter>" ];
          run = "open";
          desc = "Open the selected files";
        }
        {
          on = [ "<C-Enter>" ];
          run = "open --interactive";
          desc = "Open the selected files interactively";
        }
        {
          on = [ "y" ];
          run = "yank";
          desc = "Copy the selected files";
        }
        {
          on = [ "Y" ];
          run = "unyank";
          desc = "Cancel the yank status of files";
        }
        {
          on = [ "x" ];
          run = "yank --cut";
          desc = "Cut the selected files";
        }
        {
          on = [ "p" ];
          run = "paste";
          desc = "Paste the files";
        }
        {
          on = [ "P" ];
          run = "paste --force";
          desc = "Paste the files (overwrite if the destination exists)";
        }
        {
          on = [ "-" ];
          run = "link";
          desc = "Symlink the absolute path of files";
        }
        {
          on = [ "_" ];
          run = "link --relative";
          desc = "Symlink the relative path of files";
        }
        {
          on = [ "d" ];
          run = "remove";
          desc = "Move the files to the trash";
        }
        {
          on = [ "D" ];
          run = "remove --permanently";
          desc = "Permanently delete the files";
        }
        {
          on = [ "a" ];
          run = "create";
          desc = "Create a file or directory (ends with / for directories)";
        }
        {
          on = [ "r" ];
          run = "rename --cursor=before_ext";
          desc = "Rename a file or directory";
        }
        {
          on = [ ";" ];
          run = "shell";
          desc = "Run a shell command";
        }
        {
          on = [ ":" ];
          run = "shell --block";
          desc = "Run a shell command (block the UI until the command finishes)";
        }
        {
          on = [ "." ];
          run = "hidden toggle";
          desc = "Toggle the visibility of hidden files";
        }
        {
          on = [ "s" ];
          run = "search fd";
          desc = "Search files by name using fd";
        }
        {
          on = [ "S" ];
          run = "search rg";
          desc = "Search files by content using ripgrep";
        }
        {
          on = [ "<C-s>" ];
          run = "search none";
          desc = "Cancel the ongoing search";
        }
        {
          on = [ "z" ];
          run = "jump zoxide";
          desc = "Jump to a directory using zoxide";
        }
        {
          on = [ "Z" ];
          run = "jump fzf";
          desc = "Jump to a directory; or reveal a file using fzf";
        }

        # Linemode
        {
          on = [
            "m"
            "s"
          ];
          run = "linemode size";
          desc = "Set linemode to size";
        }
        {
          on = [
            "m"
            "p"
          ];
          run = "linemode permissions";
          desc = "Set linemode to permissions";
        }
        {
          on = [
            "m"
            "m"
          ];
          run = "linemode mtime";
          desc = "Set linemode to mtime";
        }
        {
          on = [
            "m"
            "n"
          ];
          run = "linemode none";
          desc = "Set linemode to none";
        }

        # Copy
        {
          on = [
            "c"
            "c"
          ];
          run = "copy path";
          desc = "Copy the absolute path";
        }
        {
          on = [
            "c"
            "d"
          ];
          run = "copy dirname";
          desc = "Copy the path of the parent directory";
        }
        {
          on = [
            "c"
            "f"
          ];
          run = "copy filename";
          desc = "Copy the name of the file";
        }
        {
          on = [
            "c"
            "n"
          ];
          run = "copy name_without_ext";
          desc = "Copy the name of the file without the extension";
        }

        # Filter
        {
          on = [ "f" ];
          run = "filter --smart";
          desc = "Filter the files";
        }

        # Find
        {
          on = [ "/" ];
          run = "find --smart";
          desc = "Find next file";
        }
        {
          on = [ "?" ];
          run = "find --previous --smart";
          desc = "Find previous file";
        }
        {
          on = [ "n" ];
          run = "find_arrow";
          desc = "Go to next found file";
        }
        {
          on = [ "N" ];
          run = "find_arrow --previous";
          desc = "Go to previous found file";
        }

        # Sorting
        {
          on = [
            ";"
            "m"
          ];
          run = "sort modified --dir-first";
          desc = "Sort by modified time";
        }
        {
          on = [
            ";"
            "M"
          ];
          run = "sort modified --reverse --dir-first";
          desc = "Sort by modified time (reverse)";
        }
        {
          on = [
            ";"
            "c"
          ];
          run = "sort created --dir-first";
          desc = "Sort by created time";
        }
        {
          on = [
            ";"
            "C"
          ];
          run = "sort created --reverse --dir-first";
          desc = "Sort by created time (reverse)";
        }
        {
          on = [
            ";"
            "e"
          ];
          run = "sort extension --dir-first";
          desc = "Sort by extension";
        }
        {
          on = [
            ";"
            "E"
          ];
          run = "sort extension --reverse --dir-first";
          desc = "Sort by extension (reverse)";
        }
        {
          on = [
            ";"
            "a"
          ];
          run = "sort alphabetical --dir-first";
          desc = "Sort alphabetically";
        }
        {
          on = [
            ";"
            "A"
          ];
          run = "sort alphabetical --reverse --dir-first";
          desc = "Sort alphabetically (reverse)";
        }
        {
          on = [
            ";"
            "n"
          ];
          run = "sort natural --dir-first";
          desc = "Sort naturally";
        }
        {
          on = [
            ";"
            "N"
          ];
          run = "sort natural --reverse --dir-first";
          desc = "Sort naturally (reverse)";
        }
        {
          on = [
            ";"
            "s"
          ];
          run = "sort size --dir-first";
          desc = "Sort by size";
        }
        {
          on = [
            ";"
            "S"
          ];
          run = "sort size --reverse --dir-first";
          desc = "Sort by size (reverse)";
        }

        # Tabs
        {
          on = [ "t" ];
          run = "tab_create --current";
          desc = "Create a new tab using the current path";
        }

        {
          on = [ "1" ];
          run = "tab_switch 0";
          desc = "Switch to the first tab";
        }
        {
          on = [ "2" ];
          run = "tab_switch 1";
          desc = "Switch to the second tab";
        }
        {
          on = [ "3" ];
          run = "tab_switch 2";
          desc = "Switch to the third tab";
        }
        {
          on = [ "4" ];
          run = "tab_switch 3";
          desc = "Switch to the fourth tab";
        }
        {
          on = [ "5" ];
          run = "tab_switch 4";
          desc = "Switch to the fifth tab";
        }
        {
          on = [ "6" ];
          run = "tab_switch 5";
          desc = "Switch to the sixth tab";
        }
        {
          on = [ "7" ];
          run = "tab_switch 6";
          desc = "Switch to the seventh tab";
        }
        {
          on = [ "8" ];
          run = "tab_switch 7";
          desc = "Switch to the eighth tab";
        }
        {
          on = [ "9" ];
          run = "tab_switch 8";
          desc = "Switch to the ninth tab";
        }

        {
          on = [ "[" ];
          run = "tab_switch -1 --relative";
          desc = "Switch to the previous tab";
        }
        {
          on = [ "]" ];
          run = "tab_switch 1 --relative";
          desc = "Switch to the next tab";
        }

        {
          on = [ "{" ];
          run = "tab_swap -1";
          desc = "Swap the current tab with the previous tab";
        }
        {
          on = [ "}" ];
          run = "tab_swap 1";
          desc = "Swap the current tab with the next tab";
        }

        # Tasks
        {
          on = [ "w" ];
          run = "tasks_show";
          desc = "Show the tasks manager";
        }

        # Goto
        {
          on = [
            "g"
            "h"
          ];
          run = "cd ~";
          desc = "Go to the home directory";
        }
        {
          on = [
            "g"
            "c"
          ];
          run = "cd ~/.config";
          desc = "Go to the config directory";
        }
        {
          on = [
            "g"
            "d"
          ];
          run = "cd ~/Downloads";
          desc = "Go to the downloads directory";
        }
        {
          on = [
            "g"
            "t"
          ];
          run = "cd /tmp";
          desc = "Go to the temporary directory";
        }
        {
          on = [
            "g"
            "<Space>"
          ];
          run = "cd --interactive";
          desc = "Go to a directory interactively";
        }

        # Help
        {
          on = [ "~" ];
          run = "help";
          desc = "Open help";
        }

        # GOTO
        {
          on = [
            "g"
            "h"
          ];
          run = "cd ~";
          desc = "Go to the home directory";
        }
        {
          on = [
            "g"
            "c"
          ];
          run = "cd ~/.config";
          desc = "Go to the config directory";
        }
        {
          on = [
            "g"
            "d"
          ];
          run = "cd ~/Downloads";
          desc = "Go to the downloads directory";
        }
        {
          on = [
            "g"
            "t"
          ];
          run = "cd /tmp";
          desc = "Go to the temporary directory";
        }
        {
          on = [
            "g"
            "<Space>"
          ];
          run = "cd --interactive";
          desc = "Go to a directory interactively";
        }
      ];
      tasks.keymap = [
        {
          on = [ "<Esc>" ];
          run = "close";
          desc = "Hide the task manager";
        }
        {
          on = [ "<C-q>" ];
          run = "close";
          desc = "Hide the task manager";
        }
        {
          on = [ "w" ];
          run = "close";
          desc = "Hide the task manager";
        }

        {
          on = [ "e" ];
          run = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = [ "n" ];
          run = "arrow 1";
          desc = "Move cursor down";
        }

        {
          on = [ "<Up>" ];
          run = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = [ "<Down>" ];
          run = "arrow 1";
          desc = "Move cursor down";
        }

        {
          on = [ "<Enter>" ];
          run = "inspect";
          desc = "Inspect the task";
        }
        {
          on = [ "x" ];
          run = "cancel";
          desc = "Cancel the task";
        }

        {
          on = [ "~" ];
          run = "help";
          desc = "Open help";
        }
      ];
      select.keymap = [
        {
          on = [ "<C-q>" ];
          run = "close";
          desc = "Cancel selection";
        }
        {
          on = [ "<Esc>" ];
          run = "close";
          desc = "Cancel selection";
        }
        {
          on = [ "<Enter>" ];
          run = "close --submit";
          desc = "Submit the selection";
        }

        {
          on = [ "e" ];
          run = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = [ "n" ];
          run = "arrow 1";
          desc = "Move cursor down";
        }

        {
          on = [ "E" ];
          run = "arrow -5";
          desc = "Move cursor up 5 lines";
        }
        {
          on = [ "N" ];
          run = "arrow 5";
          desc = "Move cursor down 5 lines";
        }

        {
          on = [ "<Up>" ];
          run = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = [ "<Down>" ];
          run = "arrow 1";
          desc = "Move cursor down";
        }

        {
          on = [ "<S-Up>" ];
          run = "arrow -5";
          desc = "Move cursor up 5 lines";
        }
        {
          on = [ "<S-Down>" ];
          run = "arrow 5";
          desc = "Move cursor down 5 lines";
        }

        {
          on = [ "~" ];
          run = "help";
          desc = "Open help";
        }
      ];
      input.keymap = [
        {
          on = [ "<C-q>" ];
          run = "close";
          desc = "Cancel input";
        }
        {
          on = [ "<Enter>" ];
          run = "close --submit";
          desc = "Submit the input";
        }
        {
          on = [ "<Esc>" ];
          run = "escape";
          desc = "Go back the normal mode, or cancel input";
        }

        # Mode
        {
          on = [ "i" ];
          run = "insert";
          desc = "Enter insert mode";
        }
        {
          on = [ "a" ];
          run = "insert --append";
          desc = "Enter append mode";
        }
        {
          on = [ "I" ];
          run = [
            "move -999"
            "insert"
          ];
          desc = "Move to the BOL; and enter insert mode";
        }
        {
          on = [ "A" ];
          run = [
            "move 999"
            "insert --append"
          ];
          desc = "Move to the EOL; and enter append mode";
        }
        {
          on = [ "v" ];
          run = "visual";
          desc = "Enter visual mode";
        }
        {
          on = [ "V" ];
          run = [
            "move -999"
            "visual"
            "move 999"
          ];
          desc = "Enter visual mode and select all";
        }

        # Character-wise movement
        {
          on = [ "h" ];
          run = "move -1";
          desc = "Move back a character";
        }
        {
          on = [ "i" ];
          run = "move 1";
          desc = "Move forward a character";
        }

        {
          on = [ "<Left>" ];
          run = "move -1";
          desc = "Move back a character";
        }
        {
          on = [ "<Right>" ];
          run = "move 1";
          desc = "Move forward a character";
        }

        {
          on = [ "<C-b>" ];
          run = "move -1";
          desc = "Move back a character";
        }
        {
          on = [ "<C-f>" ];
          run = "move 1";
          desc = "Move forward a character";
        }

        # Word-wise Movement
        {
          on = [ "b" ];
          run = "backward";
          desc = "Move back to the start of the current or previous word";
        }
        {
          on = [ "w" ];
          run = "forward";
          desc = "Move forward to the start of the next word";
        }
        {
          on = [ "l" ];
          run = "forward --end-of-word";
          desc = "Move forward to the end of the current or next word";
        }
        {
          on = [ "<A-b>" ];
          run = "backward";
          desc = "Move back to the start of the current or previous word";
        }
        {
          on = [ "<A-f>" ];
          run = "forward --end-of-word";
          desc = "Move forward to the end of the current or next word";
        }

        # Line-wise movement
        {
          on = [ "0" ];
          run = "move -999";
          desc = "Move to the BOL";
        }
        {
          on = [ "$" ];
          run = "move 999";
          desc = "Move to the EOL";
        }
        {
          on = [ "<C-a>" ];
          run = "move -999";
          desc = "Move to the BOL";
        }
        {
          on = [ "<C-e>" ];
          run = "move 999";
          desc = "Move to the EOL";
        }
        {
          on = [ "<Home>" ];
          run = "move -999";
          desc = "Move to the BOL";
        }
        {
          on = [ "<End>" ];
          run = "move 999";
          desc = "Move to the EOL";
        }

        # Delete
        {
          on = [ "<Backspace>" ];
          run = "backspace";
          desc = "Delete the character before the cursor";
        }
        {
          on = [ "<Delete>" ];
          run = "backspace --under";
          desc = "Delete the character under the cursor";
        }
        {
          on = [ "<C-h>" ];
          run = "backspace";
          desc = "Delete the character before the cursor";
        }
        {
          on = [ "<C-d>" ];
          run = "backspace --under";
          desc = "Delete the character under the cursor";
        }

        # Kill
        {
          on = [ "<C-u>" ];
          run = "kill bol";
          desc = "Kill backwards to the BOL";
        }
        {
          on = [ "<C-k>" ];
          run = "kill eol";
          desc = "Kill forwards to the EOL";
        }
        {
          on = [ "<C-w>" ];
          run = "kill backward";
          desc = "Kill backwards to the start of the current word";
        }
        {
          on = [ "<A-d>" ];
          run = "kill forward";
          desc = "Kill forwards to the end of the current word";
        }

        # Cut/Yank/Paste
        {
          on = [ "d" ];
          run = "delete --cut";
          desc = "Cut the selected characters";
        }
        {
          on = [ "D" ];
          run = [
            "delete --cut"
            "move 999"
          ];
          desc = "Cut until the EOL";
        }
        {
          on = [ "c" ];
          run = "delete --cut --insert";
          desc = "Cut the selected characters; and enter insert mode";
        }
        {
          on = [ "C" ];
          run = [
            "delete --cut --insert"
            "move 999"
          ];
          desc = "Cut until the EOL; and enter insert mode";
        }
        {
          on = [ "x" ];
          run = [
            "delete --cut"
            "move 1 --in-operating"
          ];
          desc = "Cut the current character";
        }
        {
          on = [ "y" ];
          run = "yank";
          desc = "Copy the selected characters";
        }
        {
          on = [ "p" ];
          run = "paste";
          desc = "Paste the copied characters after the cursor";
        }
        {
          on = [ "P" ];
          run = "paste --before";
          desc = "Paste the copied characters before the cursor";
        }

        # Undo/Redo
        {
          on = [ "u" ];
          run = "undo";
          desc = "Undo the last operation";
        }
        {
          on = [ "<C-r>" ];
          run = "redo";
          desc = "Redo the last operation";
        }

        # Help
        {
          on = [ "~" ];
          run = "help";
          desc = "Open help";
        }

        {
          on = [ "k" ];
          run = "insert";
          desc = "Enter insert mode";
        }
        {
          on = [ "K" ];
          run = [
            "move -999"
            "insert"
          ];
          desc = "Move to the BOL, and enter insert mode";
        }
      ];
      completion.keymap = [
        {
          on = [ "<C-q>" ];
          run = "close";
          desc = "Cancel completion";
        }
        {
          on = [ "<Tab>" ];
          run = "close --submit";
          desc = "Submit the completion";
        }
        {
          on = [ "<Enter>" ];
          run = [
            "close --submit"
            "close_input --submit"
          ];
          desc = "Submit the completion and input";
        }

        {
          on = [ "<A-k>" ];
          run = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = [ "<A-j>" ];
          run = "arrow 1";
          desc = "Move cursor down";
        }

        {
          on = [ "<Up>" ];
          run = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = [ "<Down>" ];
          run = "arrow 1";
          desc = "Move cursor down";
        }

        {
          on = [ "~" ];
          run = "help";
          desc = "Open help";
        }
      ];
      help.keymap = [
        {
          on = [ "e" ];
          run = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = [ "n" ];
          run = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = [ "E" ];
          run = "arrow -5";
          desc = "Move cursor up 5 lines";
        }
        {
          on = [ "N" ];
          run = "arrow 5";
          desc = "Move cursor down 5 lines";
        }

        {
          on = [ "<Esc>" ];
          run = "escape";
          desc = "Clear the filter, or hide the help";
        }
        {
          on = [ "q" ];
          run = "close";
          desc = "Exit the process";
        }
        {
          on = [ "<C-q>" ];
          run = "close";
          desc = "Hide the help";
        }

        # Navigation
        {
          on = [ "k" ];
          run = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = [ "j" ];
          run = "arrow 1";
          desc = "Move cursor down";
        }

        {
          on = [ "K" ];
          run = "arrow -5";
          desc = "Move cursor up 5 lines";
        }
        {
          on = [ "J" ];
          run = "arrow 5";
          desc = "Move cursor down 5 lines";
        }

        {
          on = [ "<Up>" ];
          run = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = [ "<Down>" ];
          run = "arrow 1";
          desc = "Move cursor down";
        }

        {
          on = [ "<S-Up>" ];
          run = "arrow -5";
          desc = "Move cursor up 5 lines";
        }
        {
          on = [ "<S-Down>" ];
          run = "arrow 5";
          desc = "Move cursor down 5 lines";
        }

        # Filtering
        {
          on = [ "/" ];
          run = "filter";
          desc = "Apply a filter for the help items";
        }
      ];
    };
    theme = {
      mgr.theme = {
        cwd = {
          fg = "cyan";
        };

        # Hovered
        hovered = {
          reversed = true;
        };
        preview_hovered = {
          underline = true;
        };

        # Find
        find_keyword = {
          fg = "yellow";
          bold = true;
          italic = true;
          underline = true;
        };
        find_position = {
          fg = "magenta";
          bg = "reset";
          bold = true;
          italic = true;
        };

        # Marker
        marker_copied = {
          fg = "lightgreen";
          bg = "lightgreen";
        };
        marker_cut = {
          fg = "lightred";
          bg = "lightred";
        };
        marker_marked = {
          fg = "lightyellow";
          bg = "lightyellow";
        };
        marker_selected = {
          fg = "lightblue";
          bg = "lightblue";
        };

        # Tab
        tab_active = {
          fg = "black";
          bg = "white";
        };
        tab_inactive = {
          fg = "white";
          bg = "darkgray";
        };
        tab_width = 1;

        # Count
        count_copied = {
          fg = "black";
          bg = "lightgreen";
        };
        count_cut = {
          fg = "black";
          bg = "lightred";
        };
        count_selected = {
          fg = "black";
          bg = "lightblue";
        };

        # Border
        border_symbol = "*";
        border_style = {
          fg = "gray";
        };

        # Highlighting
        syntect_theme = "";
      };
      status.theme = {
        separator_open = "";
        separator_close = "";
        separator_style = {
          fg = "darkgray";
          bg = "darkgray";
        };

        # Mode
        mode_normal = {
          fg = "black";
          bg = "lightblue";
          bold = true;
        };
        mode_select = {
          fg = "black";
          bg = "lightgreen";
          bold = true;
        };
        mode_unset = {
          fg = "black";
          bg = "lightmagenta";
          bold = true;
        };

        # Progress
        progress_label = {
          bold = true;
        };
        progress_normal = {
          fg = "blue";
          bg = "black";
        };
        progress_error = {
          fg = "red";
          bg = "black";
        };

        # Permissions
        permissions_t = {
          fg = "lightgreen";
        };
        permissions_r = {
          fg = "lightyellow";
        };
        permissions_w = {
          fg = "lightred";
        };
        permissions_x = {
          fg = "lightcyan";
        };
        permissions_s = {
          fg = "darkgray";
        };
      };
      select.theme = {
        border = {
          fg = "blue";
        };
        active = {
          fg = "magenta";
        };
        inactive = { };
      };
      input.theme = {
        border = {
          fg = "blue";
        };
        title = { };
        value = { };
        selected = {
          reversed = true;
        };
      };
      completion.theme = {
        border = {
          fg = "blue";
        };
        active = {
          bg = "darkgray";
        };
        inactive = { };

        # Icons
        icon_file = "";
        icon_folder = "";
        icon_command = "";
      };
      tasks.theme = {
        border = {
          fg = "blue";
        };
        title = { };
        hovered = {
          underline = true;
        };
      };
      which.theme = {
        cols = 3;
        mask = {
          bg = "black";
        };
        cand = {
          fg = "lightcyan";
        };
        rest = {
          fg = "darkgray";
        };
        desc = {
          fg = "magenta";
        };
        separator = "  ";
        separator_style = {
          fg = "darkgray";
        };
      };
      help.theme = {
        on = {
          fg = "magenta";
        };
        run = {
          fg = "cyan";
        };
        desc = {
          fg = "gray";
        };
        hovered = {
          bg = "darkgray";
          bold = true;
        };
        footer = {
          fg = "black";
          bg = "white";
        };
      };
      filetype.theme = {
        rules = [
          # Images
          {
            mime = "image/*";
            fg = "cyan";
          }

          # Videos
          {
            mime = "video/*";
            fg = "yellow";
          }
          {
            mime = "audio/*";
            fg = "yellow";
          }

          # Archives
          {
            mime = "application/zip";
            fg = "magenta";
          }
          {
            mime = "application/gzip";
            fg = "magenta";
          }
          {
            mime = "application/x-tar";
            fg = "magenta";
          }
          {
            mime = "application/x-bzip";
            fg = "magenta";
          }
          {
            mime = "application/x-bzip2";
            fg = "magenta";
          }
          {
            mime = "application/x-7z-compressed";
            fg = "magenta";
          }
          {
            mime = "application/x-rar";
            fg = "magenta";
          }
          {
            mime = "application/xz";
            fg = "magenta";
          }

          # Documents
          {
            mime = "application/doc";
            fg = "green";
          }
          {
            mime = "application/pdf";
            fg = "green";
          }
          {
            mime = "application/rtf";
            fg = "green";
          }
          {
            mime = "application/vnd.*";
            fg = "green";
          }

          # Fallback
          # { url = "*", fg = "white" },
          {
            url = "*/";
            fg = "blue";
          }
        ];
      };
      icon.theme = {
        rules = [
          # Programming
          {
            url = "*.c";
            text = "";
            fg = "#599eff";
          }
          {
            url = "*.cpp";
            text = "";
            fg = "#519aba";
          }
          {
            url = "*.class";
            text = "";
            fg = "#cc3e44";
          }
          {
            url = "*.cs";
            text = "󰌛";
            fg = "#596706";
          }
          {
            url = "*.css";
            text = "";
            fg = "#42a5f5";
          }
          {
            url = "*.elm";
            text = "";
            fg = "#4391d2";
          }
          {
            url = "*.fish";
            text = "";
            fg = "#4d5a5e";
          }
          {
            url = "*.go";
            text = "";
            fg = "#519aba";
          }
          {
            url = "*.h";
            text = "";
            fg = "#a074c4";
          }
          {
            url = "*.hpp";
            text = "";
            fg = "#a074c4";
          }
          {
            url = "*.html";
            text = "";
            fg = "#e44d26";
          }
          {
            url = "*.jar";
            text = "";
            fg = "#cc3e44";
          }
          {
            url = "*.java";
            text = "";
            fg = "#cc3e44";
          }
          {
            url = "*.js";
            text = "";
            fg = "#F1F134";
          }
          {
            url = "*.jsx";
            text = "";
            fg = "#20c2e3";
          }
          {
            url = "*.lua";
            text = "";
            fg = "#51a0cf";
          }
          {
            url = "*.nix";
            text = "";
            fg = "#7ebae4";
          }
          {
            url = "*.nu";
            text = ">";
            fg = "#3aa675";
          }
          {
            url = "*.php";
            text = "";
            fg = "#a074c4";
          }
          {
            url = "*.py";
            text = "";
            fg = "#ffbc03";
          }
          {
            url = "*.rb";
            text = "";
            fg = "#701516";
          }
          {
            url = "*.rs";
            text = "";
            fg = "#dea584";
          }
          {
            url = "*.sbt";
            text = "";
            fg = "#4d5a5e";
          }
          {
            url = "*.scala";
            text = "";
            fg = "#cc463e";
          }
          {
            url = "*.scss";
            text = "";
            fg = "#f55385";
          }
          {
            url = "*.sh";
            text = "";
            fg = "#4d5a5e";
          }
          {
            url = "*.swift";
            text = "";
            fg = "#e37933";
          }
          {
            url = "*.ts";
            text = "";
            fg = "#519aba";
          }
          {
            url = "*.tsx";
            text = "";
            fg = "#1354bf";
          }
          {
            url = "*.vim";
            text = "";
            fg = "#019833";
          }
          {
            url = "*.vue";
            text = "󰡄";
            fg = "#8dc149";
          }

          # Text
          {
            url = "*.conf";
            text = "";
            fg = "#6d8086";
          }
          {
            url = "*.ini";
            text = "";
            fg = "#6d8086";
          }
          {
            url = "*.json";
            text = "";
            fg = "#cbcb41";
          }
          {
            url = "*.kdl";
            text = "";
            fg = "#6d8086";
          }
          {
            url = "*.md";
            text = "";
            fg = "#ffffff";
          }
          {
            url = "*.toml";
            text = "";
            fg = "#ffffff";
          }
          {
            url = "*.txt";
            text = "";
            fg = "#89e051";
          }
          {
            url = "*.yaml";
            text = "";
            fg = "#6d8086";
          }
          {
            url = "*.yml";
            text = "";
            fg = "#6d8086";
          }

          # Archives
          {
            url = "*.7z";
            text = "";
          }
          {
            url = "*.bz2";
            text = "";
          }
          {
            url = "*.gz";
            text = "";
          }
          {
            url = "*.rar";
            text = "";
          }
          {
            url = "*.tar";
            text = "";
          }
          {
            url = "*.xz";
            text = "";
          }
          {
            url = "*.zip";
            text = "";
          }

          # Images
          {
            url = "*.HEIC";
            text = "";
            fg = "#a074c4";
          }
          {
            url = "*.avif";
            text = "";
            fg = "#a074c4";
          }
          {
            url = "*.bmp";
            text = "";
            fg = "#a074c4";
          }
          {
            url = "*.gif";
            text = "";
            fg = "#a074c4";
          }
          {
            url = "*.ico";
            text = "";
            fg = "#cbcb41";
          }
          {
            url = "*.jpeg";
            text = "";
            fg = "#a074c4";
          }
          {
            url = "*.jpg";
            text = "";
            fg = "#a074c4";
          }
          {
            url = "*.png";
            text = "";
            fg = "#a074c4";
          }
          {
            url = "*.svg";
            text = "";
            fg = "#FFB13B";
          }
          {
            url = "*.webp";
            text = "";
            fg = "#a074c4";
          }

          # Movies
          {
            url = "*.avi";
            text = "";
            fg = "#FD971F";
          }
          {
            url = "*.mkv";
            text = "";
            fg = "#FD971F";
          }
          {
            url = "*.mov";
            text = "";
            fg = "#FD971F";
          }
          {
            url = "*.mp4";
            text = "";
            fg = "#FD971F";
          }
          {
            url = "*.webm";
            text = "";
            fg = "#FD971F";
          }

          # Audio
          {
            url = "*.aac";
            text = "";
            fg = "#66D8EF";
          }
          {
            url = "*.flac";
            text = "";
            fg = "#66D8EF";
          }
          {
            url = "*.m4a";
            text = "";
            fg = "#66D8EF";
          }
          {
            url = "*.mp3";
            text = "";
            fg = "#66D8EF";
          }
          {
            url = "*.ogg";
            text = "";
            fg = "#66D8EF";
          }
          {
            url = "*.wav";
            text = "";
            fg = "#66D8EF";
          }

          # Documents
          {
            url = "*.csv";
            text = "";
            fg = "#89e051";
          }
          {
            url = "*.doc";
            text = "";
            fg = "#185abd";
          }
          {
            url = "*.doct";
            text = "";
            fg = "#185abd";
          }
          {
            url = "*.docx";
            text = "";
            fg = "#185abd";
          }
          {
            url = "*.dot";
            text = "";
            fg = "#185abd";
          }
          {
            url = "*.ods";
            text = "";
            fg = "#207245";
          }
          {
            url = "*.ots";
            text = "";
            fg = "#207245";
          }
          {
            url = "*.pdf";
            text = "";
            fg = "#b30b00";
          }
          {
            url = "*.pom";
            text = "";
            fg = "#cc3e44";
          }
          {
            url = "*.pot";
            text = "";
            fg = "#cb4a32";
          }
          {
            url = "*.potx";
            text = "";
            fg = "#cb4a32";
          }
          {
            url = "*.ppm";
            text = "";
            fg = "#a074c4";
          }
          {
            url = "*.ppmx";
            text = "";
            fg = "#cb4a32";
          }
          {
            url = "*.pps";
            text = "";
            fg = "#cb4a32";
          }
          {
            url = "*.ppsx";
            text = "";
            fg = "#cb4a32";
          }
          {
            url = "*.ppt";
            text = "";
            fg = "#cb4a32";
          }
          {
            url = "*.pptx";
            text = "";
            fg = "#cb4a32";
          }
          {
            url = "*.xlc";
            text = "";
            fg = "#207245";
          }
          {
            url = "*.xlm";
            text = "";
            fg = "#207245";
          }
          {
            url = "*.xls";
            text = "";
            fg = "#207245";
          }
          {
            url = "*.xlsm";
            text = "";
            fg = "#207245";
          }
          {
            url = "*.xlsx";
            text = "";
            fg = "#207245";
          }
          {
            url = "*.xlt";
            text = "";
            fg = "#207245";
          }

          # Lockfiles
          {
            url = "*.lock";
            text = "";
            fg = "#bbbbbb";
          }

          # Misc
          {
            url = "*.bin";
            text = "";
            fg = "#9F0500";
          }
          {
            url = "*.exe";
            text = "";
            fg = "#9F0500";
          }
          {
            url = "*.pkg";
            text = "";
            fg = "#9F0500";
          }

          # Dotfiles
          {
            url = ".DS_Store";
            text = "";
            fg = "#41535b";
          }
          {
            url = ".bashprofile";
            text = "";
            fg = "#89e051";
          }
          {
            url = ".bashrc";
            text = "";
            fg = "#89e051";
          }
          {
            url = ".gitattributes";
            text = "";
            fg = "#41535b";
          }
          {
            url = ".gitignore";
            text = "";
            fg = "#41535b";
          }
          {
            url = ".gitmodules";
            text = "";
            fg = "#41535b";
          }
          {
            url = ".vimrc";
            text = "";
            fg = "#019833";
          }
          {
            url = ".zprofile";
            text = "";
            fg = "#89e051";
          }
          {
            url = ".zshenv";
            text = "";
            fg = "#89e051";
          }
          {
            url = ".zshrc";
            text = "";
            fg = "#89e051";
          }

          # Named files
          {
            url = "COPYING";
            text = "󰿃";
            fg = "#cbcb41";
          }
          {
            url = "Containerfile";
            text = "󰡨";
            fg = "#458ee6";
          }
          {
            url = "Dockerfile";
            text = "󰡨";
            fg = "#458ee6";
          }
          {
            url = "LICENSE";
            text = "󰿃";
            fg = "#d0bf41";
          }

          # Directories
          {
            url = ".config/";
            text = "";
          }
          {
            url = ".git/";
            text = "";
          }
          {
            url = "Desktop/";
            text = "";
          }
          {
            url = "Development/";
            text = "";
          }
          {
            url = "Documents/";
            text = "";
          }
          {
            url = "Downloads/";
            text = "";
          }
          {
            url = "Library/";
            text = "";
          }
          {
            url = "Movies/";
            text = "";
          }
          {
            url = "Music/";
            text = "";
          }
          {
            url = "Pictures/";
            text = "";
          }
          {
            url = "Public/";
            text = "";
          }
          {
            url = "Videos/";
            text = "";
          }

          # Default
          {
            url = "*";
            text = "";
          }
          {
            url = "*/";
            text = "";
          }
        ];
      };
    };
  };
}
