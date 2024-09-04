-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.g.mapleader = " "
local wk = require("which-key")

wk.add({
  --------------------
  -- GENERAL / MISC --
  --------------------
  {
    mode = { "n", "v" },
    { "<C-s>", "<cmd>w<CR>", desc = "[ 💾 ] Save file" },
    { "Q",     "<cmd>q<CR>", desc = "[ 🚪 ] Quit" },

    { "k",     "i",      desc = "[✏️ ] Insert" },
    { "K",     "I",      desc = "[✏️ ] Insert at beginning of line" },
    { "<C-a>", "<ESC>A", desc = "[✏️ ] Move to end of line and enter insert mode" },

    { "Y", '"+y', desc = "[📋] Copy to clipboard" },
    { "l", "u",   desc = "[↩️ ] Undo"               },

    { ",.",           "%",                   desc = "[ 🧩 ] Find matching pair" },
    { "<leader>tt",   "<cmd>s/ /\t/g<CR>",   desc = "[ 🔄 ] Space to tab (visual)" },
    { "<leader><CR>", "<cmd>nohlsearch<CR>", desc = "[ 🧹 ] Clear search highlight" },

    { "<leader>rc", "<cmd>e $HOME/.config/nvim/lua/config/options.lua<CR>", desc = "[ ⚙️ ] Open nvim options.lua" },
    { "<leader>rp", "<cmd>e $HOME/.config/nvim/lua/plugins/.<CR>",          desc = "[ 🧩 ] Open lazy plugins dir" },
  },


   ---------------------
   -- CURSOR MOVEMENT --
   ---------------------
  {
    mode = { "n", "s", "v", "x" },
    { "<C-e>", "5<C-y>", desc = "[ 🖼️⬆️ ] Move viewport up" },
    { "<C-n>", "5<C-e>", desc = "[ 🖼️⬇️ ] Move viewport down" },
    { "h",     "h",      desc = "[⬅️ ] Move cursor left" },
    { "n",     "j",      desc = "[⬇️ ] Move cursor down" },
    { "N",     "5j",     desc = "[⏬] Move cursor 5 down" },
    { "e",     "k",      desc = "[⬆️ ] Move cursor up" },
    { "E",     "5k",     desc = "[⏫] Move cursor 5 up" },
    { "i",     "l",      desc = "[➡️ ] Move cursor right" },

    { "w",     "w",   desc = "[🦘➡️ ] Move cursor 1 word forward" },
    { "W",     "5w",  desc = "[🦘➡️ ] Move cursor 5 words forward" },
    { "l",     "e",   desc = "[🔤➡️ ] Cursor to end of word" },
    { "L",     "5e",  desc = "[🔤➡️5️⃣ ] Cursor to end of word (x5)" },
    { "B",     "5b",  desc = "[🦘⬅️ ] Move cursor 5 words back" },
    { "B",     "5b",  desc = "[🦘⬅️ ] Move cursor 5 words back" },
    { "H",     "0",   desc = "[⏮️ ] Move to start of line" },
    { "I",     "$",   desc = "[⏭️ ] Move to end of line" },
  },


  ---------------------------
  -- SPLIT PANE MANAGEMENT --
  ---------------------------
  {
    { "<leader>w", group = "[ 🪟 ] Windows" },
    -- Focus
    { "<leader>we",  "<C-w>k",             desc = "[🔍⬆️ ] Focus split up"       },
    { "<leader>wh",  "<C-w>h",             desc = "[🔍⬅️ ] Focus split left"     },
    { "<leader>wi",  "<C-w>l",             desc = "[🔍➡️ ] Focus split right"    },
    { "<leader>wn",  "<C-w>j",             desc = "[🔍⬇️ ] Focus split down"     },
    -- Misc
    { "<leader>wq",  "<C-w>j<cmd>q<CR>",   desc = "[🚫⬇️ ] Close split below"    },
    { "<leader>wv",    "<C-w>t<C-w>H",     desc = "[ 🔄 ] Make splits vertical" },
    -- Rotate
    { "<leader>wrh", "<C-w>b<C-w>H",       desc = "[🔄] Rotate splits -90°"     },
    { "<leader>wri", "<C-w>b<C-w>K",       desc = "[🔁] Rotate splits 90°"      },
    -- New Split
    { "<leader>ws", group = "[✂️ ] Split" },
    { "<leader>wsh",   "<cmd>set nosplitright<CR><cmd>vsplit<CR><cmd>set splitright<CR>",  desc = "[⬅️ ] New split left"  },
    { "<leader>wsn",   "<cmd>set splitbelow<CR><cmd>split<CR>",                            desc = "[⬇️ ] New split down"  },
    { "<leader>wse",   "<cmd>set nosplitbelow<CR><cmd>split<CR><cmd>set splitbelow<CR>",   desc = "[⬆️ ] New split up"    },
    { "<leader>wsi",   "<cmd>set splitright<CR><cmd>vsplit<CR>",                           desc = "[➡️ ] New split right" },
  },
  {
    -- RESIZE PANES
    { "<left>",  "<cmd>vertical resize +5<CR>", desc = "[◀️ ] Resize split left"  },
    { "<down>",  "<cmd>res +5<CR>",             desc = "[🔽] Resize split down"  },
    { "<up>",    "<cmd>res -5<CR>",             desc = "[🔼] Resize split up"    },
    { "<right>", "<cmd>vertical resize -5<CR>", desc = "[▶️ ] Resize split right" },
  },


 ----------------------------------
 -- COMMAND MODE CURSOR MOVEMENT --
 ----------------------------------
 {
    mode = { "c" },
    { "<C-a>",   "<Home>",      desc = "[⏮️ ] Move to beginning of line" },
    { "<C-b>",   "<Left>",      desc = "[⬅️ ] Move cursor left"          },
    { "<C-e>",   "<End>",       desc = "[⏭️ ] Move to end of line"       },
    { "<C-f>",   "<Right>",     desc = "[➡️ ] Move cursor right"         },
    { "<C-n>",   "<Down>",      desc = "[⬇️ ] Next command"              },
    { "<C-p>",   "<Up>",        desc = "[⬆️ ] Previous command"          },
    { "<M-b>",   "<S-Left>",    desc = "[🔤⬅️ ] Move word left"          },
    { "<M-w>",   "<S-Right>",   desc = "[🔤➡️ ] Move word right"         },
  },


  ----------
  -- TABS --
  ----------
  {
    { "<leader>t", group = "[ 📑 ] Tabs" },
    { "<leader>t,", "<cmd>-tabmove<CR>", desc = "[ ⬅️🔄 ] Move tab left" },
    { "<leader>t.", "<cmd>+tabmove<CR>", desc = "[ ➡️🔄 ] Move tab right" },
    { "<leader>th", "<cmd>-tabnext<CR>", desc = "[ ⬅️ ] Previous tab" },
    { "<leader>ti", "<cmd>+tabnext<CR>", desc = "[ ➡️ ] Next tab" },
    { "<leader>tt", "<cmd>tabe<CR>",     desc = "[ ➕ ] New tab" },
  },


  --------------
  -- TERMINAL --
  --------------
  {
    { "<C-n>", "<C-\\><C-n>", desc = "[ 🏃 ] Escape terminal", mode = "t" },
    { "<C-o>", "<C-\\><C-n><C-o>", desc = "[ 🚪 ] Close terminal", mode = "t" },
  }
})

-- Remove default mappings
vim.keymap.del("n", "<C-J>")
vim.keymap.del("n", "<C-K>")
vim.keymap.del("n", "<C-L>")

