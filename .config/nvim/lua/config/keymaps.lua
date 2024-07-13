-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.g.mapleader = " "
local wk = require("which-key")

-- General keybinds
wk.register({
  Q = { "<cmd>q<CR>", "[ 🚪 ] Quit" },
  ["<C-s>"] = { "<cmd>w<CR>", "[ 💾 ] Save file" },
  l = { "u", "[ ↩️ ] Undo" },
  k = { "i", "[ ✏️ ] Insert" },
  K = { "I", "[ ⏮️✏️ ] Insert at beginning of line" },
  Y = { '"+y', "[ 📋 ] Copy to clipboard" },
  [",."] = { "%", "[ 🧩 ] Find matching pair" },
  ["<leader>"] = {
    ["<CR>"] = { "<cmd>nohlsearch<CR>", "[ 🧹 ] Clear search highlight" },
    tt = {
      "<cmd>s/    /\t/g<CR>",
      "[ 🔄 ] Space to tab (visual)",
      mode = { "n", "v" },
    },
    rc = { "<cmd>e $HOME/.config/nvim/lua/config/options.lua<CR>", "[ ⚙️ ] Open nvim options.lua" },
    rp = { "<cmd>e $HOME/.config/nvim/lua/plugins/.<CR>", "[ 🧩 ] Open lazy plugins dir" },
  },
}, { mode = { "n", "v" } })

-- Cursor movement
local cursor_movement = {
  e = { "k", "[⬆️ ] Move cursor up" },
  n = { "j", "[⬇️ ] Move cursor down" },
  h = { "h", "[⬅️ ] Move cursor left" },
  i = { "l", "[➡️ ] Move cursor right" },
  E = { "5k", "[⏫] Move cursor 5 up" },
  N = { "5j", "[⏬] Move cursor 5 down" },
  H = { "0", "[⏮️ ] Move to start of line" },
  I = { "$", "[⏭️ ] Move to end of line" },
  W = { "5w", "[🦘➡️ ] Move cursor 5 words forward" },
  B = { "5b", "[🦘⬅️ ] Move cursor 5 words back" },
  l = { "e", "[🔤➡️ ] Cursor to end of word" },
  L = { "5e", "[🔤➡️5️⃣ ] Cursor to end of word (x5)" },
  ["<C-e>"] = { "5<C-y>", "[ 🖼️⬆️ ] Move viewport up" },
  ["<C-n>"] = { "5<C-e>", "[ 🖼️⬇️ ] Move viewport down" },
}
wk.register(cursor_movement, { mode = { "n", "v" } })
wk.register(cursor_movement, { mode = { "", "s", "x" } })

-- Insert mode cursor movement
wk.register({
  ["<C-a>"] = { "<ESC>A", "[➡️✏️ ] Move to end of line and enter insert mode" },
}, { mode = "i" })

-- Command mode cursor movement
wk.register({
  ["<C-a>"] = { "<Home>", "[⏮️ ] Move to beginning of line" },
  ["<C-e>"] = { "<End>", "[⏭️ ] Move to end of line" },
  ["<C-p>"] = { "<Up>", "[⬆️ ] Previous command" },
  ["<C-n>"] = { "<Down>", "[⬇️ ] Next command" },
  ["<C-b>"] = { "<Left>", "[⬅️ ] Move cursor left" },
  ["<C-f>"] = { "<Right>", "[➡️ ] Move cursor right" },
  ["<M-b>"] = { "<S-Left>", "[🔤⬅️ ] Move word left" },
  ["<M-w>"] = { "<S-Right>", "[🔤➡️ ] Move word right" },
}, { mode = "c" })

-- Window management
wk.register({
  w = {
    name = "[ 🪟 ] Windows",
    s = {
      name = "[ ✂️ ] Split",
      e = { "<cmd>set nosplitbelow<CR><cmd>split<CR><cmd>set splitbelow<CR>", "[ ⬆️ ] New split up" },
      n = { "<cmd>set splitbelow<CR><cmd>split<CR>", "[ ⬇️ ] New split down" },
      h = { "<cmd>set nosplitright<CR><cmd>vsplit<CR><cmd>set splitright<CR>", "[ ⬅️ ] New split left" },
      i = { "<cmd>set splitright<CR><cmd>vsplit<CR>", "[ ➡️ ] New split right" },
    },
    e = { "<C-w>k", "[ 🔍⬆️ ] Focus split up" },
    n = { "<C-w>j", "[ 🔍⬇️ ] Focus split down" },
    h = { "<C-w>h", "[ 🔍⬅️ ] Focus split left" },
    i = { "<C-w>l", "[ 🔍➡️ ] Focus split right" },
    v = { "<C-w>t<C-w>H", "[ 🔄 ] Make splits vertical" },
    ri = { "<C-w>b<C-w>K", "[ 🔁 ] Rotate splits 90°" },
    rh = { "<C-w>b<C-w>H", "[ 🔄 ] Rotate splits -90°" },
    q = { "<C-w>j<cmd>q<CR>", "[ 🚫⬇️ ] Close split below" },
  },
}, { prefix = "<leader>" })

-- Resizing splits
wk.register({
  ["<up>"] = { "<cmd>res -5<CR>", "[ 🔼 ] Resize split up" },
  ["<down>"] = { "<cmd>res +5<CR>", "[ 🔽 ] Resize split down" },
  ["<left>"] = { "<cmd>vertical resize +5<CR>", "[ ◀️ ] Resize split left" },
  ["<right>"] = { "<cmd>vertical resize -5<CR>", "[ ▶️ ] Resize split right" },
}, { mode = "n" })

-- Tab management
wk.register({
  t = {
    name = "[ 📑 ] Tabs",
    t = { "<cmd>tabe<CR>", "[ ➕ ] New tab" },
    h = { "<cmd>-tabnext<CR>", "[ ⬅️ ] Previous tab" },
    i = { "<cmd>+tabnext<CR>", "[ ➡️ ] Next tab" },
    H = { "<cmd>-tabmove<CR>", "[ ⬅️🔄 ] Move tab left" },
    I = { "<cmd>+tabmove<CR>", "[ ➡️🔄 ] Move tab right" },
  },
}, { prefix = "<leader>" })

-- Terminal behavior
wk.register({
  ["<C-n>"] = { "<C-\\><C-n>", "[ 🏃 ] Escape terminal" },
  ["<C-o>"] = { "<C-\\><C-n><C-o>", "[ 🚪 ] Close terminal" },
}, { mode = "t" })

-- Remove default mappings
vim.keymap.del("n", "<C-J>")
vim.keymap.del("n", "<C-K>")
vim.keymap.del("n", "<C-L>") --vim.keymap.set("n", ",.", "%", { desc = "Find Pair" })
--vim.keymap.set("v", "ki", "$%", { desc = "Find Pair" })
--vim.keymap.set("i", "<C-y>", "<ESC>A {}<ESC>i<CR><ESC>ko", { desc = "insert a pair of {} and goto next line" })
--vim.keymap.set({ "n", "v", "", "s", "x" }, "e", "k", { desc = "[ ⇧] move Cursor Up" })
--vim.keymap.set({ "n", "v", "", "s", "x" }, "n", "j", { desc = "[ ⇩] move Cursor Down" })
--vim.keymap.set({ "n", "v", "", "s", "x" }, "h", "h", { desc = "[ ⇦] move Cursor Left" })
--vim.keymap.set({ "n", "v", "", "s", "x" }, "i", "l", { desc = "[ ⇨] move Cursor Right" })
--
--vim.keymap.set({ "n", "v" }, "E", "5k", { desc = "[ ⇧⁵] move Cursor 5 Up" })
--vim.keymap.set({ "n", "v" }, "N", "5j", { desc = "[ ⇩⁵] move Cursor 5 Down" })
--
--vim.keymap.set({ "n", "v" }, "H", "0", { desc = "Move start of line" })
--vim.keymap.set({ "n", "v" }, "I", "$", { desc = "Move end of line" })
--
--vim.keymap.set("n", "gu", "gk", { desc = "move up gk -> gu" })
--vim.keymap.set("n", "ge", "gj", { desc = "move down gj -> ge" })
--
--vim.keymap.set("n", "\v", "v$h", { desc = "???" })
--
---- FASTER IN-LINE NAVIGATION
--vim.keymap.set({ "n", "v" }, "W", "5w", { desc = "[ 󰈑 ⁵] move Cursor 5 words forward" })
--vim.keymap.set({ "n", "v" }, "B", "5b", { desc = "[  ⁵] move Cursor 5 words back" })
--
---- SET h (SAME AS n, CURSOR LEFT) TO 'END OF WORD'
--vim.keymap.set("n", "l", "e", { desc = "Cursor to end of word" })
--vim.keymap.set("n", "L", "5e", { desc = "Cursor to end of word (x5)" })
---- CTRL + U OR E WILL MOVE UP/DOWN THE VIEW PORT WITHOUT MOVING THE CURSOR
--vim.keymap.set({ "n", "v" }, "<C-e>", "5<C-y>", { desc = "[🖵  ⇧] move Viewport Up" })
--vim.keymap.set({ "n", "v" }, "<C-n>", "5<C-e>", { desc = "[🖵  ⇩] move Viewport Down " })
--
---- INSERT MODE CURSOR MOVEMENT
--vim.keymap.set("i", "<C-a>", "<ESC>A")
--
---- COMMAND MODE CURSOR MOVEMENT
--vim.keymap.set("c", "<C-a>", "<Home>")
--vim.keymap.set("c", "<C-e>", "<End>")
--vim.keymap.set("c", "<C-p>", "<Up>")
--vim.keymap.set("c", "<C-n>", "<Down>")
--vim.keymap.set("c", "<C-b>", "<Left>")
--vim.keymap.set("c", "<C-f>", "<Right>")
--vim.keymap.set("c", "<M-b>", "<S-Left>")
--vim.keymap.set("c", "<M-w>", "<S-Right>")
----}}}
--
---- ================= SPLIT MANAGMENT ===================== {{{
--wk.register({
--    e = { ""}
--  },
--})
----vim.keymap.set(
----  "n",
----  "<LEADER>wse",
----  "<CMD>set nosplitbelow<CR><CMD>split<CR><CMD>set splitbelow<CR>",
----  { desc = "[+  ⇧] new Split Up" }
----)
----vim.keymap.set("n", "<LEADER>wsn", "<CMD>set splitbelow<CR><CMD>split<CR>", { desc = "[+  ⇩] new Split Down" })
----vim.keymap.set(
----  "n",
----  "<LEADER>wsh",
----  "<CMD>set nosplitright<CR><CMD>vsplit<CR><CMD>set splitright<CR>",
----  { desc = "[+  ⇦] new Split Left" }
----)
----vim.keymap.set("n", "<LEADER>wsi", "<CMD>set splitright<CR><CMD>vsplit<CR>", { desc = "[+  ⇨] new Split Right" })
--
--vim.keymap.set({ "n", "t" }, "<LEADER>we", "<C-w>k", { desc = "[ ⇧ ] Cursor to Split Up" })
--vim.keymap.set({ "n", "t" }, "<LEADER>wn", "<C-w>j", { desc = "[ ⇩ ] Cursor to Split Down" })
--vim.keymap.set({ "n", "t" }, "<LEADER>wh", "<C-w>h", { desc = "[ ⇦ ] Cursor to Split Left" })
--vim.keymap.set({ "n", "t" }, "<LEADER>wi", "<C-w>l", { desc = "[ ⇨ ] Cursor to Split Right" })
--
--vim.keymap.set("n", "<up>", "<CMD>res -5<CR>", { desc = "Resize split 0,-5" })
--vim.keymap.set("n", "<down>", "<CMD>res +5<CR>", { desc = "Resize split 0,+5" })
--vim.keymap.set("n", "<left>", "<CMD>vertical resize +5<CR>", { desc = "Resize split +5,0" })
--vim.keymap.set("n", "<right>", "<CMD>vertical resize -5<CR>", { desc = "Resize split -5,0" })
--
--vim.keymap.set("n", "<LEADER>wh", "<C-w>t<C-w>K", { desc = "[ ⇉ ] Make splits [H]orizontal" })
--vim.keymap.set("n", "<LEADER>wv", "<C-w>t<C-w>H", { desc = "[ ⇉ ] Make splits [V]ertical" })
--
--vim.keymap.set("n", "<LEADER>wri", "<C-w>b<C-w>K", { desc = "[ 󱞫 ] Rotate Splits 90°" })
--vim.keymap.set("n", "<LEADER>wrh", "<C-w>b<C-w>H", { desc = "[ 󱞧 ]Rotate Splits -90°" })
--
--vim.keymap.set("n", "<LEADER>wq", "<C-w>j<CMD>q<CR>", { desc = "[  ⇩] Close Split Below" })
--
---- TAB MANAGEMENT {{{
--vim.keymap.set("n", "<LEADER>tt", "<CMD>tabe<CR>", { desc = "[+ 󰓩 ] New Tab" })
--
--vim.keymap.set("n", "<LEADER>th", "<CMD>-tabnext<CR>", { desc = "[ 󰓩 ⇦] select Prev Tab" })
--vim.keymap.set("n", "<LEADER>ti", "<CMD>+tabnext<CR>", { desc = "[ 󰓩 ⇨] select Next Tab" })
--
--vim.keymap.set("n", "<LEADER>tH", "<CMD>-tabmove<CR>", { desc = "[󰓩 󰘶 ⇦] tab Move Before" })
--vim.keymap.set("n", "<LEADER>tI", "<CMD>+tabmove<CR>", { desc = "[󰓩 󰘶 ⇨] tab Move After" })
--
---- NOTE: Doesn't seem to work:
---- vim.keymap.set("n", "<TAB>c", "<CMD>tab split<CR>", { desc = "New Tab from [C]urrent" })
---- vim.keymap.set('n', '<LEADER>dw', '/\(\<\w\+\>\)\_s*\1', {desc='adjacent duplicate words'})
--
--vim.keymap.del("n", "<C-J>")
--vim.keymap.del("n", "<C-K>")
--vim.keymap.del("n", "<C-L>")
---- }}}
--
---- =================== TERM BEHAVIORS ====================
--vim.keymap.set("t", "<C-n>", "<C-\\><C-n>", { desc = "escape terminal, allowing excmds" })
--vim.keymap.set("t", "<C-o>", "<C-\\><C-n><C-o>", { desc = "close terminal" })
