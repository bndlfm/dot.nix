{ pkgs, ... }:{
  programs.yazi = {
    enable = true;
    package = pkgs.yazi.override {
      # Broken AGAIN
      _7zz = (pkgs._7zz.override { useUasm = true; });
    };
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    keymap = {
      manager.keymap = [
        { on = [ "<Esc>" ]; run = "escape"; desc = "Exit visual mode, clear selected, or cancel search"; }
        { on = [ "q" ]; run = "quit"; desc = "Exit the process"; }
        { on = [ "Q" ]; run = "quit --no-cwd-file"; desc = "Exit the process without writing cwd-file"; }
        { on = [ "<C-q>" ]; run = "close"; desc = "Close the current tab, or quit if it is last tab"; }
        { on = [ "<C-z>" ]; run = "suspend"; desc = "Suspend the process"; }

        # NAVIGATION
        { on = [ "e" ]; run = "arrow -1"; desc = "Move cursor up"; }
        { on = [ "n" ]; run = "arrow 1"; desc = "Move cursor down"; }
        { on = [ "E" ]; run = "arrow -5"; desc = "Move cursor up 5 lines"; }
        { on = [ "N" ]; run = "arrow 5"; desc = "Move cursor down 5 lines"; }
        { on = [ "h" ]; run = [ "leave" "escape --visual --select" ]; desc = "Go back to the parent directory"; }
        { on = [ "i" ]; run = [ "enter" "escape --visual --select" ]; desc = "Enter the child directory"; }
        { on = [ "H" ]; run = "back"; desc = "Go back to the previous directory"; }
        { on = [ "I" ]; run = "forward"; desc = "Go forward to the next directory"; }
        { on = [ "<S-Up>" ]; run = "arrow -5"; desc = "Move cursor up 5 lines"; }
        { on = [ "<S-Down>" ]; run = "arrow 5"; desc = "Move cursor down 5 lines"; }

        { on = [ "<C-u>" ]; run = "arrow -50%"; desc = "Move cursor up half page"; }
        { on = [ "<C-d>" ]; run = "arrow 50%"; desc = "Move cursor down half page"; }
        { on = [ "<C-b>" ]; run = "arrow -100%"; desc = "Move cursor up one page"; }
        { on = [ "<C-f>" ]; run = "arrow 100%"; desc = "Move cursor down one page"; }

        { on = [ "<C-PageUp>" ]; run = "arrow -50%"; desc = "Move cursor up half page"; }
        { on = [ "<C-PageDown>" ]; run = "arrow 50%"; desc = "Move cursor down half page"; }
        { on = [ "<PageUp>" ]; run = "arrow -100%"; desc = "Move cursor up one page"; }
        { on = [ "<PageDown>" ]; run = "arrow 100%"; desc = "Move cursor down one page"; }

        # PREVIEW
        { on = [ "<A-e>" ]; run = "seek -5"; desc = "Seek up 5 units in the preview"; }
        { on = [ "<A-n>" ]; run = "seek 5"; desc = "Seek down 5 units in the preview"; }
        { on = [ "<A-PageUp>" ]; run = "seek -5"; desc = "Seek up 5 units in the preview"; }
        { on = [ "<A-PageDown>" ]; run = "seek 5"; desc = "Seek down 5 units in the preview"; }

        { on = [ "<Up>" ]; run = "arrow -1"; desc = "Move cursor up"; }
        { on = [ "<Down>" ]; run = "arrow 1"; desc = "Move cursor down"; }
        { on = [ "<Left>" ]; run = "leave"; desc = "Go back to the parent directory"; }
        { on = [ "<Right>" ]; run = "enter"; desc = "Enter the child directory"; }

        { on = [ "g" "g" ]; run = "arrow -99999999"; desc = "Move cursor to the top"; }
        { on = [ "G" ]; run = "arrow 99999999"; desc = "Move cursor to the bottom"; }

        # Selection
        { on = [ "<Space>" ]; run = [ "select --state=none" "arrow 1" ]; desc = "Toggle the current selection state"; }
        { on = [ "v" ]; run = "visual_mode"; desc = "Enter visual mode (selection mode)"; }
        { on = [ "V" ]; run = "visual_mode --unset"; desc = "Enter visual mode (unset mode)"; }
        { on = [ "<C-a>" ]; run = "select_all --state=true"; desc = "Select all files"; }
        { on = [ "<C-r>" ]; run = "select_all --state=none"; desc = "Inverse selection of all files"; }

        # Operation
        { on = [ "o" ]; run = "open"; desc = "Open the selected files"; }
        { on = [ "O" ]; run = "open --interactive"; desc = "Open the selected files interactively"; }
        { on = [ "<Enter>" ]; run = "open"; desc = "Open the selected files"; }
        { on = [ "<C-Enter>" ]; run = "open --interactive"; desc = "Open the selected files interactively"; }
        { on = [ "y" ]; run = "yank"; desc = "Copy the selected files"; }
        { on = [ "Y" ]; run = "unyank"; desc = "Cancel the yank status of files"; }
        { on = [ "x" ]; run = "yank --cut"; desc = "Cut the selected files"; }
        { on = [ "p" ]; run = "paste"; desc = "Paste the files"; }
        { on = [ "P" ]; run = "paste --force"; desc = "Paste the files (overwrite if the destination exists)"; }
        { on = [ "-" ]; run = "link"; desc = "Symlink the absolute path of files"; }
        { on = [ "_" ]; run = "link --relative"; desc = "Symlink the relative path of files"; }
        { on = [ "d" ]; run = "remove"; desc = "Move the files to the trash"; }
        { on = [ "D" ]; run = "remove --permanently"; desc = "Permanently delete the files"; }
        { on = [ "a" ]; run = "create"; desc = "Create a file or directory (ends with / for directories)"; }
        { on = [ "r" ]; run = "rename --cursor=before_ext"; desc = "Rename a file or directory"; }
        { on = [ ";" ]; run = "shell"; desc = "Run a shell command"; }
        { on = [ ":" ]; run = "shell --block"; desc = "Run a shell command (block the UI until the command finishes)"; }
        { on = [ "." ]; run = "hidden toggle"; desc = "Toggle the visibility of hidden files"; }
        { on = [ "s" ]; run = "search fd"; desc = "Search files by name using fd"; }
        { on = [ "S" ]; run = "search rg"; desc = "Search files by content using ripgrep"; }
        { on = [ "<C-s>" ]; run = "search none"; desc = "Cancel the ongoing search"; }
        { on = [ "z" ]; run = "jump zoxide"; desc = "Jump to a directory using zoxide"; }
        { on = [ "Z" ]; run = "jump fzf"; desc = "Jump to a directory; or reveal a file using fzf"; }

        # Linemode
        { on = [ "m" "s" ]; run = "linemode size"; desc = "Set linemode to size"; }
        { on = [ "m" "p" ]; run = "linemode permissions"; desc = "Set linemode to permissions"; }
        { on = [ "m" "m" ]; run = "linemode mtime"; desc = "Set linemode to mtime"; }
        { on = [ "m" "n" ]; run = "linemode none"; desc = "Set linemode to none"; }

        # Copy
        { on = [ "c" "c" ]; run = "copy path"; desc = "Copy the absolute path"; }
        { on = [ "c" "d" ]; run = "copy dirname"; desc = "Copy the path of the parent directory"; }
        { on = [ "c" "f" ]; run = "copy filename"; desc = "Copy the name of the file"; }
        { on = [ "c" "n" ]; run = "copy name_without_ext"; desc = "Copy the name of the file without the extension"; }

        # Filter
        { on = [ "f" ]; run = "filter --smart"; desc = "Filter the files"; }

        # Find
        { on = [ "/" ]; run = "find --smart"; desc = "Find next file"; }
        { on = [ "?" ]; run = "find --previous --smart"; desc = "Find previous file"; }
        { on = [ "n" ]; run = "find_arrow"; desc = "Go to next found file"; }
        { on = [ "N" ]; run = "find_arrow --previous"; desc = "Go to previous found file"; }

        # Sorting
        { on = [ ";" "m" ]; run = "sort modified --dir-first"; desc = "Sort by modified time"; }
        { on = [ ";" "M" ]; run = "sort modified --reverse --dir-first"; desc = "Sort by modified time (reverse)"; }
        { on = [ ";" "c" ]; run = "sort created --dir-first"; desc = "Sort by created time"; }
        { on = [ ";" "C" ]; run = "sort created --reverse --dir-first"; desc = "Sort by created time (reverse)"; }
        { on = [ ";" "e" ]; run = "sort extension --dir-first"; desc = "Sort by extension"; }
        { on = [ ";" "E" ]; run = "sort extension --reverse --dir-first"; desc = "Sort by extension (reverse)"; }
        { on = [ ";" "a" ]; run = "sort alphabetical --dir-first"; desc = "Sort alphabetically"; }
        { on = [ ";" "A" ]; run = "sort alphabetical --reverse --dir-first"; desc = "Sort alphabetically (reverse)"; }
        { on = [ ";" "n" ]; run = "sort natural --dir-first"; desc = "Sort naturally"; }
        { on = [ ";" "N" ]; run = "sort natural --reverse --dir-first"; desc = "Sort naturally (reverse)"; }
        { on = [ ";" "s" ]; run = "sort size --dir-first"; desc = "Sort by size"; }
        { on = [ ";" "S" ]; run = "sort size --reverse --dir-first"; desc = "Sort by size (reverse)"; }

        # Tabs
        { on = [ "t" ]; run = "tab_create --current"; desc = "Create a new tab using the current path"; }

        { on = [ "1" ]; run = "tab_switch 0"; desc = "Switch to the first tab"; }
        { on = [ "2" ]; run = "tab_switch 1"; desc = "Switch to the second tab"; }
        { on = [ "3" ]; run = "tab_switch 2"; desc = "Switch to the third tab"; }
        { on = [ "4" ]; run = "tab_switch 3"; desc = "Switch to the fourth tab"; }
        { on = [ "5" ]; run = "tab_switch 4"; desc = "Switch to the fifth tab"; }
        { on = [ "6" ]; run = "tab_switch 5"; desc = "Switch to the sixth tab"; }
        { on = [ "7" ]; run = "tab_switch 6"; desc = "Switch to the seventh tab"; }
        { on = [ "8" ]; run = "tab_switch 7"; desc = "Switch to the eighth tab"; }
        { on = [ "9" ]; run = "tab_switch 8"; desc = "Switch to the ninth tab"; }

        { on = [ "[" ]; run = "tab_switch -1 --relative"; desc = "Switch to the previous tab"; }
        { on = [ "]" ]; run = "tab_switch 1 --relative"; desc = "Switch to the next tab"; }

        { on = [ "{" ]; run = "tab_swap -1"; desc = "Swap the current tab with the previous tab"; }
        { on = [ "}" ]; run = "tab_swap 1"; desc = "Swap the current tab with the next tab"; }

        # Tasks
        { on = [ "w" ]; run = "tasks_show"; desc = "Show the tasks manager"; }

        # Goto
        { on = [ "g" "h" ]; run = "cd ~"; desc = "Go to the home directory"; }
        { on = [ "g" "c" ]; run = "cd ~/.config"; desc = "Go to the config directory"; }
        { on = [ "g" "d" ]; run = "cd ~/Downloads"; desc = "Go to the downloads directory"; }
        { on = [ "g" "t" ]; run = "cd /tmp"; desc = "Go to the temporary directory"; }
        { on = [ "g" "<Space>" ]; run = "cd --interactive"; desc = "Go to a directory interactively"; }

        # Help
        { on = [ "~" ]; run = "help"; desc = "Open help"; }

        # GOTO
        { on = [ "g" "h" ]; run = "cd ~"; desc = "Go to the home directory"; }
        { on = [ "g" "c" ]; run = "cd ~/.config"; desc = "Go to the config directory"; }
        { on = [ "g" "d" ]; run = "cd ~/Downloads"; desc = "Go to the downloads directory"; }
        { on = [ "g" "t" ]; run = "cd /tmp"; desc = "Go to the temporary directory"; }
        { on = [ "g" "<Space>" ]; run = "cd --interactive"; desc = "Go to a directory interactively"; }
      ];
      tasks.keymap = [
        { on = [ "<Esc>" ]; run = "close"; desc = "Hide the task manager"; }
        { on = [ "<C-q>" ]; run = "close"; desc = "Hide the task manager"; }
        { on = [ "w" ]; run = "close"; desc = "Hide the task manager"; }

        { on = [ "e" ]; run = "arrow -1"; desc = "Move cursor up"; }
        { on = [ "n" ]; run = "arrow 1"; desc = "Move cursor down"; }

        { on = [ "<Up>" ]; run = "arrow -1"; desc = "Move cursor up"; }
        { on = [ "<Down>" ]; run = "arrow 1"; desc = "Move cursor down"; }

        { on = [ "<Enter>" ]; run = "inspect"; desc = "Inspect the task"; }
        { on = [ "x" ]; run = "cancel"; desc = "Cancel the task"; }

        { on = [ "~" ]; run = "help"; desc = "Open help"; }
      ];
      select.keymap = [
        { on = [ "<C-q>" ]; run = "close"; desc = "Cancel selection"; }
        { on = [ "<Esc>" ]; run = "close"; desc = "Cancel selection"; }
        { on = [ "<Enter>" ]; run = "close --submit"; desc = "Submit the selection"; }

        { on = [ "e" ]; run = "arrow -1"; desc = "Move cursor up"; }
        { on = [ "n" ]; run = "arrow 1"; desc = "Move cursor down"; }

        { on = [ "E" ]; run = "arrow -5"; desc = "Move cursor up 5 lines"; }
        { on = [ "N" ]; run = "arrow 5"; desc = "Move cursor down 5 lines"; }

        { on = [ "<Up>" ]; run = "arrow -1"; desc = "Move cursor up"; }
        { on = [ "<Down>" ]; run = "arrow 1"; desc = "Move cursor down"; }

        { on = [ "<S-Up>" ]; run = "arrow -5"; desc = "Move cursor up 5 lines"; }
        { on = [ "<S-Down>" ]; run = "arrow 5"; desc = "Move cursor down 5 lines"; }

        { on = [ "~" ]; run = "help"; desc = "Open help"; }
      ];
      input.keymap = [
        { on = [ "<C-q>" ]; run = "close"; desc = "Cancel input"; }
        { on = [ "<Enter>" ]; run = "close --submit"; desc = "Submit the input"; }
        { on = [ "<Esc>" ]; run = "escape"; desc = "Go back the normal mode, or cancel input"; }

        # Mode
        { on = [ "i" ]; run = "insert"; desc = "Enter insert mode"; }
        { on = [ "a" ]; run = "insert --append"; desc = "Enter append mode"; }
        { on = [ "I" ]; run = [ "move -999" "insert" ]; desc = "Move to the BOL; and enter insert mode"; }
        { on = [ "A" ]; run = [ "move 999" "insert --append" ]; desc = "Move to the EOL; and enter append mode"; }
        { on = [ "v" ]; run = "visual"; desc = "Enter visual mode"; }
        { on = [ "V" ]; run = [ "move -999" "visual" "move 999" ]; desc = "Enter visual mode and select all"; }

        # Character-wise movement
        { on = [ "h" ]; run = "move -1"; desc = "Move back a character"; }
        { on = [ "i" ]; run = "move 1"; desc = "Move forward a character"; }

        { on = [ "<Left>" ]; run = "move -1"; desc = "Move back a character"; }
        { on = [ "<Right>" ]; run = "move 1"; desc = "Move forward a character"; }

        { on = [ "<C-b>" ]; run = "move -1"; desc = "Move back a character"; }
        { on = [ "<C-f>" ]; run = "move 1"; desc = "Move forward a character"; }

        # Word-wise Movement
        { on = [ "b" ]; run = "backward"; desc = "Move back to the start of the current or previous word"; }
        { on = [ "w" ]; run = "forward"; desc = "Move forward to the start of the next word"; }
        { on = [ "l" ]; run = "forward --end-of-word"; desc = "Move forward to the end of the current or next word"; }
        { on = [ "<A-b>" ]; run = "backward"; desc = "Move back to the start of the current or previous word"; }
        { on = [ "<A-f>" ]; run = "forward --end-of-word"; desc = "Move forward to the end of the current or next word"; }

        # Line-wise movement
        { on = [ "0" ]; run = "move -999"; desc = "Move to the BOL"; }
        { on = [ "$" ]; run = "move 999"; desc = "Move to the EOL"; }
        { on = [ "<C-a>" ]; run = "move -999"; desc = "Move to the BOL"; }
        { on = [ "<C-e>" ]; run = "move 999"; desc = "Move to the EOL"; }
        { on = [ "<Home>" ]; run = "move -999"; desc = "Move to the BOL"; }
        { on = [ "<End>" ]; run = "move 999"; desc = "Move to the EOL"; }

        # Delete
        { on = [ "<Backspace>" ]; run = "backspace"; desc = "Delete the character before the cursor"; }
        { on = [ "<Delete>" ]; run = "backspace --under"; desc = "Delete the character under the cursor"; }
        { on = [ "<C-h>" ]; run = "backspace"; desc = "Delete the character before the cursor"; }
        { on = [ "<C-d>" ]; run = "backspace --under"; desc = "Delete the character under the cursor"; }

        # Kill
        { on = [ "<C-u>" ]; run = "kill bol"; desc = "Kill backwards to the BOL"; }
        { on = [ "<C-k>" ]; run = "kill eol"; desc = "Kill forwards to the EOL"; }
        { on = [ "<C-w>" ]; run = "kill backward"; desc = "Kill backwards to the start of the current word"; }
        { on = [ "<A-d>" ]; run = "kill forward"; desc = "Kill forwards to the end of the current word"; }

        # Cut/Yank/Paste
        { on = [ "d" ]; run = "delete --cut"; desc = "Cut the selected characters"; }
        { on = [ "D" ]; run = [ "delete --cut" "move 999" ]; desc = "Cut until the EOL"; }
        { on = [ "c" ]; run = "delete --cut --insert"; desc = "Cut the selected characters; and enter insert mode"; }
        { on = [ "C" ]; run = [ "delete --cut --insert" "move 999" ]; desc = "Cut until the EOL; and enter insert mode"; }
        { on = [ "x" ]; run = [ "delete --cut" "move 1 --in-operating" ]; desc = "Cut the current character"; }
        { on = [ "y" ]; run = "yank"; desc = "Copy the selected characters"; }
        { on = [ "p" ]; run = "paste"; desc = "Paste the copied characters after the cursor"; }
        { on = [ "P" ]; run = "paste --before"; desc = "Paste the copied characters before the cursor"; }

        # Undo/Redo
        { on = [ "u" ]; run = "undo"; desc = "Undo the last operation"; }
        { on = [ "<C-r>" ]; run = "redo"; desc = "Redo the last operation"; }

        # Help
        { on = [ "~" ]; run = "help"; desc = "Open help"; }

        { on = [ "k" ]; run = "insert"; desc = "Enter insert mode"; }
        { on = [ "K" ]; run = [ "move -999" "insert" ]; desc = "Move to the BOL, and enter insert mode"; }
      ];
      completion.keymap = [
        { on = [ "<C-q>" ]; run = "close"; desc = "Cancel completion"; }
        { on = [ "<Tab>" ]; run = "close --submit"; desc = "Submit the completion"; }
        { on = [ "<Enter>" ]; run = [ "close --submit" "close_input --submit" ]; desc = "Submit the completion and input"; }

        { on = [ "<A-k>" ]; run = "arrow -1"; desc = "Move cursor up"; }
        { on = [ "<A-j>" ]; run = "arrow 1"; desc = "Move cursor down"; }

        { on = [ "<Up>" ]; run = "arrow -1"; desc = "Move cursor up"; }
        { on = [ "<Down>" ]; run = "arrow 1"; desc = "Move cursor down"; }

        { on = [ "~" ]; run = "help"; desc = "Open help"; }
      ];
      help.keymap = [
        { on = [ "e" ]; run = "arrow -1"; desc = "Move cursor up"; }
        { on = [ "n" ]; run = "arrow 1"; desc = "Move cursor down"; }
        { on = [ "E" ]; run = "arrow -5"; desc = "Move cursor up 5 lines"; }
        { on = [ "N" ]; run = "arrow 5"; desc = "Move cursor down 5 lines"; }

        { on = [ "<Esc>" ]; run = "escape"; desc = "Clear the filter, or hide the help"; }
        { on = [ "q" ]; run = "close"; desc = "Exit the process"; }
        { on = [ "<C-q>" ]; run = "close"; desc = "Hide the help"; }

        # Navigation
        { on = [ "k" ]; run = "arrow -1"; desc = "Move cursor up"; }
        { on = [ "j" ]; run = "arrow 1"; desc = "Move cursor down"; }

        { on = [ "K" ]; run = "arrow -5"; desc = "Move cursor up 5 lines"; }
        { on = [ "J" ]; run = "arrow 5"; desc = "Move cursor down 5 lines"; }

        { on = [ "<Up>" ]; run = "arrow -1"; desc = "Move cursor up"; }
        { on = [ "<Down>" ]; run = "arrow 1"; desc = "Move cursor down"; }

        { on = [ "<S-Up>" ]; run = "arrow -5"; desc = "Move cursor up 5 lines"; }
        { on = [ "<S-Down>" ]; run = "arrow 5"; desc = "Move cursor down 5 lines"; }

        # Filtering
        { on = [ "/" ]; run = "filter"; desc = "Apply a filter for the help items"; }
      ];
    };
    theme = {
      manager.theme = {
        cwd = { fg = "cyan"; };

        # Hovered
        hovered = { reversed = true; };
        preview_hovered = { underline = true; };

        # Find
        find_keyword = { fg = "yellow"; bold = true; italic = true; underline = true; };
        find_position = { fg = "magenta"; bg = "reset"; bold = true; italic = true; };

        # Marker
        marker_copied = { fg = "lightgreen"; bg = "lightgreen"; };
        marker_cut = { fg = "lightred"; bg = "lightred"; };
        marker_marked = { fg = "lightyellow"; bg = "lightyellow"; };
        marker_selected = { fg = "lightblue"; bg = "lightblue"; };

        # Tab
        tab_active = { fg = "black"; bg = "white"; };
        tab_inactive = { fg = "white"; bg = "darkgray"; };
        tab_width = 1;

        # Count
        count_copied = { fg = "black"; bg = "lightgreen"; };
        count_cut = { fg = "black"; bg = "lightred"; };
        count_selected = { fg = "black"; bg = "lightblue"; };

        # Border
        border_symbol = "*";
        border_style = { fg = "gray"; };

        # Highlighting
        syntect_theme = "";
      };
      status.theme = {
        separator_open = "";
        separator_close = "";
        separator_style = { fg = "darkgray"; bg = "darkgray"; };

        # Mode
        mode_normal = { fg = "black"; bg = "lightblue"; bold = true; };
        mode_select = { fg = "black"; bg = "lightgreen"; bold = true; };
        mode_unset = { fg = "black"; bg = "lightmagenta"; bold = true; };

        # Progress
        progress_label = { bold = true; };
        progress_normal = { fg = "blue"; bg = "black"; };
        progress_error = { fg = "red"; bg = "black"; };

        # Permissions
        permissions_t = { fg = "lightgreen"; };
        permissions_r = { fg = "lightyellow"; };
        permissions_w = { fg = "lightred"; };
        permissions_x = { fg = "lightcyan"; };
        permissions_s = { fg = "darkgray"; };
      };
      select.theme = {
        border = { fg = "blue"; };
        active = { fg = "magenta"; };
        inactive = { };
      };
      input.theme = {
        border = { fg = "blue"; };
        title = { };
        value = { };
        selected = { reversed = true; };
      };
      completion.theme = {
        border = { fg = "blue"; };
        active = { bg = "darkgray"; };
        inactive = { };

        # Icons
        icon_file = "";
        icon_folder = "";
        icon_command = "";
      };
      tasks.theme = {
        border = { fg = "blue"; };
        title = { };
        hovered = { underline = true; };
      };
      which.theme = {
        cols = 3;
        mask = { bg = "black"; };
        cand = { fg = "lightcyan"; };
        rest = { fg = "darkgray"; };
        desc = { fg = "magenta"; };
        separator = "  ";
        separator_style = { fg = "darkgray"; };
      };
      help.theme = {
        on = { fg = "magenta"; };
        exec = { fg = "cyan"; };
        desc = { fg = "gray"; };
        hovered = { bg = "darkgray"; bold = true; };
        footer = { fg = "black"; bg = "white"; };
      };
      filetype.theme = {
        rules = [
          # Images
          { mime = "image/*"; fg = "cyan"; }

          # Videos
          { mime = "video/*"; fg = "yellow"; }
          { mime = "audio/*"; fg = "yellow"; }

          # Archives
          { mime = "application/zip"; fg = "magenta"; }
          { mime = "application/gzip"; fg = "magenta"; }
          { mime = "application/x-tar"; fg = "magenta"; }
          { mime = "application/x-bzip"; fg = "magenta"; }
          { mime = "application/x-bzip2"; fg = "magenta"; }
          { mime = "application/x-7z-compressed"; fg = "magenta"; }
          { mime = "application/x-rar"; fg = "magenta"; }
          { mime = "application/xz"; fg = "magenta"; }

          # Documents
          { mime = "application/doc"; fg = "green"; }
          { mime = "application/pdf"; fg = "green"; }
          { mime = "application/rtf"; fg = "green"; }
          { mime = "application/vnd.*"; fg = "green"; }

          # Fallback
          # { name = "*", fg = "white" },
          { name = "*/"; fg = "blue"; }
        ];
      };
      icon.theme = {
        rules = [
          # Programming
          { name = "*.c"; text = ""; fg = "#599eff"; }
          { name = "*.cpp"; text = ""; fg = "#519aba"; }
          { name = "*.class"; text = ""; fg = "#cc3e44"; }
          { name = "*.cs"; text = "󰌛"; fg = "#596706"; }
          { name = "*.css"; text = ""; fg = "#42a5f5"; }
          { name = "*.elm"; text = ""; fg = "#4391d2"; }
          { name = "*.fish"; text = ""; fg = "#4d5a5e"; }
          { name = "*.go"; text = ""; fg = "#519aba"; }
          { name = "*.h"; text = ""; fg = "#a074c4"; }
          { name = "*.hpp"; text = ""; fg = "#a074c4"; }
          { name = "*.html"; text = ""; fg = "#e44d26"; }
          { name = "*.jar"; text = ""; fg = "#cc3e44"; }
          { name = "*.java"; text = ""; fg = "#cc3e44"; }
          { name = "*.js"; text = ""; fg = "#F1F134"; }
          { name = "*.jsx"; text = ""; fg = "#20c2e3"; }
          { name = "*.lua"; text = ""; fg = "#51a0cf"; }
          { name = "*.nix"; text = ""; fg = "#7ebae4"; }
          { name = "*.nu"; text = ">"; fg = "#3aa675"; }
          { name = "*.php"; text = ""; fg = "#a074c4"; }
          { name = "*.py"; text = ""; fg = "#ffbc03"; }
          { name = "*.rb"; text = ""; fg = "#701516"; }
          { name = "*.rs"; text = ""; fg = "#dea584"; }
          { name = "*.sbt"; text = ""; fg = "#4d5a5e"; }
          { name = "*.scala"; text = ""; fg = "#cc463e"; }
          { name = "*.scss"; text = ""; fg = "#f55385"; }
          { name = "*.sh"; text = ""; fg = "#4d5a5e"; }
          { name = "*.swift"; text = ""; fg = "#e37933"; }
          { name = "*.ts"; text = ""; fg = "#519aba"; }
          { name = "*.tsx"; text = ""; fg = "#1354bf"; }
          { name = "*.vim"; text = ""; fg = "#019833"; }
          { name = "*.vue"; text = "󰡄"; fg = "#8dc149"; }

          # Text
          { name = "*.conf"; text = ""; fg = "#6d8086"; }
          { name = "*.ini"; text = ""; fg = "#6d8086"; }
          { name = "*.json"; text = ""; fg = "#cbcb41"; }
          { name = "*.kdl"; text = ""; fg = "#6d8086"; }
          { name = "*.md"; text = ""; fg = "#ffffff"; }
          { name = "*.toml"; text = ""; fg = "#ffffff"; }
          { name = "*.txt"; text = ""; fg = "#89e051"; }
          { name = "*.yaml"; text = ""; fg = "#6d8086"; }
          { name = "*.yml"; text = ""; fg = "#6d8086"; }

          # Archives
          { name = "*.7z"; text = ""; }
          { name = "*.bz2"; text = ""; }
          { name = "*.gz"; text = ""; }
          { name = "*.rar"; text = ""; }
          { name = "*.tar"; text = ""; }
          { name = "*.xz"; text = ""; }
          { name = "*.zip"; text = ""; }

          # Images
          { name = "*.HEIC"; text = ""; fg = "#a074c4"; }
          { name = "*.avif"; text = ""; fg = "#a074c4"; }
          { name = "*.bmp"; text = ""; fg = "#a074c4"; }
          { name = "*.gif"; text = ""; fg = "#a074c4"; }
          { name = "*.ico"; text = ""; fg = "#cbcb41"; }
          { name = "*.jpeg"; text = ""; fg = "#a074c4"; }
          { name = "*.jpg"; text = ""; fg = "#a074c4"; }
          { name = "*.png"; text = ""; fg = "#a074c4"; }
          { name = "*.svg"; text = ""; fg = "#FFB13B"; }
          { name = "*.webp"; text = ""; fg = "#a074c4"; }

          # Movies
          { name = "*.avi"; text = ""; fg = "#FD971F"; }
          { name = "*.mkv"; text = ""; fg = "#FD971F"; }
          { name = "*.mov"; text = ""; fg = "#FD971F"; }
          { name = "*.mp4"; text = ""; fg = "#FD971F"; }
          { name = "*.webm"; text = ""; fg = "#FD971F"; }

          # Audio
          { name = "*.aac"; text = ""; fg = "#66D8EF"; }
          { name = "*.flac"; text = ""; fg = "#66D8EF"; }
          { name = "*.m4a"; text = ""; fg = "#66D8EF"; }
          { name = "*.mp3"; text = ""; fg = "#66D8EF"; }
          { name = "*.ogg"; text = ""; fg = "#66D8EF"; }
          { name = "*.wav"; text = ""; fg = "#66D8EF"; }

          # Documents
          { name = "*.csv"; text = ""; fg = "#89e051"; }
          { name = "*.doc"; text = ""; fg = "#185abd"; }
          { name = "*.doct"; text = ""; fg = "#185abd"; }
          { name = "*.docx"; text = ""; fg = "#185abd"; }
          { name = "*.dot"; text = ""; fg = "#185abd"; }
          { name = "*.ods"; text = ""; fg = "#207245"; }
          { name = "*.ots"; text = ""; fg = "#207245"; }
          { name = "*.pdf"; text = ""; fg = "#b30b00"; }
          { name = "*.pom"; text = ""; fg = "#cc3e44"; }
          { name = "*.pot"; text = ""; fg = "#cb4a32"; }
          { name = "*.potx"; text = ""; fg = "#cb4a32"; }
          { name = "*.ppm"; text = ""; fg = "#a074c4"; }
          { name = "*.ppmx"; text = ""; fg = "#cb4a32"; }
          { name = "*.pps"; text = ""; fg = "#cb4a32"; }
          { name = "*.ppsx"; text = ""; fg = "#cb4a32"; }
          { name = "*.ppt"; text = ""; fg = "#cb4a32"; }
          { name = "*.pptx"; text = ""; fg = "#cb4a32"; }
          { name = "*.xlc"; text = ""; fg = "#207245"; }
          { name = "*.xlm"; text = ""; fg = "#207245"; }
          { name = "*.xls"; text = ""; fg = "#207245"; }
          { name = "*.xlsm"; text = ""; fg = "#207245"; }
          { name = "*.xlsx"; text = ""; fg = "#207245"; }
          { name = "*.xlt"; text = ""; fg = "#207245"; }

          # Lockfiles
          { name = "*.lock"; text = ""; fg = "#bbbbbb"; }

          # Misc
          { name = "*.bin"; text = ""; fg = "#9F0500"; }
          { name = "*.exe"; text = ""; fg = "#9F0500"; }
          { name = "*.pkg"; text = ""; fg = "#9F0500"; }

          # Dotfiles
          { name = ".DS_Store"; text = ""; fg = "#41535b"; }
          { name = ".bashprofile"; text = ""; fg = "#89e051"; }
          { name = ".bashrc"; text = ""; fg = "#89e051"; }
          { name = ".gitattributes"; text = ""; fg = "#41535b"; }
          { name = ".gitignore"; text = ""; fg = "#41535b"; }
          { name = ".gitmodules"; text = ""; fg = "#41535b"; }
          { name = ".vimrc"; text = ""; fg = "#019833"; }
          { name = ".zprofile"; text = ""; fg = "#89e051"; }
          { name = ".zshenv"; text = ""; fg = "#89e051"; }
          { name = ".zshrc"; text = ""; fg = "#89e051"; }

          # Named files
          { name = "COPYING"; text = "󰿃"; fg = "#cbcb41"; }
          { name = "Containerfile"; text = "󰡨"; fg = "#458ee6"; }
          { name = "Dockerfile"; text = "󰡨"; fg = "#458ee6"; }
          { name = "LICENSE"; text = "󰿃"; fg = "#d0bf41"; }

          # Directories
          { name = ".config/"; text = ""; }
          { name = ".git/"; text = ""; }
          { name = "Desktop/"; text = ""; }
          { name = "Development/"; text = ""; }
          { name = "Documents/"; text = ""; }
          { name = "Downloads/"; text = ""; }
          { name = "Library/"; text = ""; }
          { name = "Movies/"; text = ""; }
          { name = "Music/"; text = ""; }
          { name = "Pictures/"; text = ""; }
          { name = "Public/"; text = ""; }
          { name = "Videos/"; text = ""; }

          # Default
          { name = "*"; text = ""; }
          { name = "*/"; text = ""; }
        ];
      };
    };
  };
}
