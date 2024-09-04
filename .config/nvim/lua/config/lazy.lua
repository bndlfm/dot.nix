-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.clipboard:prepend({ "unnamed", "unnamedplus" })
--vim.o.colorcolumn = 100
vim.o.completeopt = "longest,noinsert,menuone,noselect,preview"
vim.o.cursorline = true
vim.o.expandtab = true

vim.wo.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevel = 99
vim.o.foldenable = true
vim.go.foldlevelstart = 99
--vim.opt.modelineexpr = true
vim.go.modelineexpr = true

vim.o.inccommand = "split"
vim.o.indentexpr = ""
vim.o.ignorecase = true
vim.o.lazyredraw = false
vim.o.list = true
vim.o.listchars = "tab:| ,trail:▫"
vim.bo.modeline = true
vim.go.modelines = 5
vim.g.neoterm_autoscroll = 1
vim.o.number = true
vim.o.relativenumber = true
vim.g.python_host_prog = "/usr/bin/python"
vim.g.python3_host_prog = "/usr/bin/python3"
vim.o.scrolloff = 4
vim.o.secure = true
vim.o.shiftwidth = 2
vim.o.showmode = false
vim.o.smartcase = true
vim.o.softtabstop = 2
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.tabstop = 8
vim.o.timeout = true
vim.o.ttimeoutlen = 0
vim.o.tw = 0
vim.o.visualbell = true
vim.o.updatetime = 100
vim.o.viewoptions = "cursor,folds,slash,unix"
vim.o.virtualedit = "block"
vim.wo.wrap = false
vim.o.undolevels = 9999999
vim.o.undofile = true

vim.cmd([[
  silent !mkdir -p $home/.config/nvim/tmp/backup
  silent !mkdir -p $HOME/.config/nvim/tmp/undo
  set backupdir=$HOME/.config/nvim/tmp/backup,.
  set directory=$HOME/.config/nvim/tmp/backup,.
  if has ('persistent_undo' )
    set undofile
    set undodir=$HOME/.config/nvim/tmp/undo,.
  endif
]])

vim.cmd([[
  set formatoptions-=tc
  set shortmess+=c
  let &t_ut=''
  "let g:clipboard = {
  "      \   'name': 'clipBoard',
  "      \   'copy': {
  "      \      '+': ['tmux', 'load-buffer', '-'],
  "      \      '*': ['tmux', 'load-buffer', '-'],
  "      \    },
  "      \   'paste': {
  "      \      '+': ['tmux', 'save-buffer', '-'],
  "      \      '*': ['tmux', 'save-buffer', '-'],
  "      \   },
  "      \   'cache_enabled': 1,
  "      \ }
]])
  -- Customization for Pmenu
    --vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#282C34", fg = "NONE" })
    --vim.api.nvim_set_hl(0, "Pmenu", { fg = "#C5CDD9", bg = "#22252A" })
    --
    --vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = "#7E8294", bg = "NONE", strikethrough = true })
    --vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#82AAFF", bg = "NONE", bold = true })
    --vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#82AAFF", bg = "NONE", bold = true })
    --vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#C792EA", bg = "NONE", italic = true })
    --
    --vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = "#EED8DA", bg = "#B5585F" })
    --vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#EED8DA", bg = "#B5585F" })
    --vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = "#EED8DA", bg = "#B5585F" })
    --
    --vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#C3E88D", bg = "#9FBD73" })
    --vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = "#C3E88D", bg = "#9FBD73" })
    --vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#C3E88D", bg = "#9FBD73" })
    --
    --vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = "#FFE082", bg = "#D4BB6C" })
    --vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { fg = "#FFE082", bg = "#D4BB6C" })
    --vim.api.nvim_set_hl(0, "CmpItemKindReference", { fg = "#FFE082", bg = "#D4BB6C" })
    --
    --vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#EADFF0", bg = "#A377BF" })
    --vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = "#EADFF0", bg = "#A377BF" })
    --vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#EADFF0", bg = "#A377BF" })
    --vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = "#EADFF0", bg = "#A377BF" })
    --vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = "#EADFF0", bg = "#A377BF" })
    --
    --vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#C5CDD9", bg = "#7E8294" })
    --vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = "#C5CDD9", bg = "#7E8294" })
    --
    --vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = "#F5EBD9", bg = "#D4A959" })
    --vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#F5EBD9", bg = "#D4A959" })
    --vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = "#F5EBD9", bg = "#D4A959" })
    --
    --vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#DDE5F5", bg = "#6C8ED4" })
    --vim.api.nvim_set_hl(0, "CmpItemKindValue", { fg = "#DDE5F5", bg = "#6C8ED4" })
    --vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { fg = "#DDE5F5", bg = "#6C8ED4" })
    --
    --vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#D8EEEB", bg = "#58B5A8" })
    --vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = "#D8EEEB", bg = "#58B5A8" })
    --vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { fg = "#D8EEEB", bg = "#58B5A8" })

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- automatically check for plugin updates
  checker = { enabled = true },
  opts = {
    colorscheme = "nordic",
  },
})
