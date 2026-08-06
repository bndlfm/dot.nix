-- LazyVim defaults (Low priority)
vim.opt.autowrite = true
vim.opt.conceallevel = 2
vim.opt.confirm = true
vim.opt.formatoptions = "jcroqlnt"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.laststatus = 3
vim.opt.mouse = "a"
vim.opt.pumblend = 10
vim.opt.pumheight = 10
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
vim.opt.shiftround = true
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.spelllang = { "en" }
vim.opt.splitkeep = "screen"
vim.opt.termguicolors = true
vim.opt.wildmode = "longest:full,full"
vim.opt.winminwidth = 5
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- USER EXPLICIT PREFERENCES (High priority - takes precedence)
vim.g["aniseed#env"] = true -- Conjure (FENNEL)

vim.opt.clipboard:prepend({ "unnamed", "unnamedplus" })
vim.o.completeopt = "longest,noinsert,menuone,noselect,preview"
vim.o.cursorline = true

vim.o.foldmethod = "marker"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldenable = true
vim.go.modelineexpr = true

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
vim.o.showmode = false
vim.o.smartcase = true
vim.o.splitright = true
vim.o.splitbelow = true
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

----------------------
--- TABS v. SPACES ---
----------------------
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.softtabstop = 4
vim.o.tabstop = 4

-- Right-click menu integration
vim.keymap.set("n", "<RightMouse>", function()
  vim.cmd.exec('"normal! \\<RightMouse>"')
  local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
  require("menu").open(options, { mouse = true })
end, {})

-- Directory setup and persistent undo
vim.cmd([[
  silent !mkdir -p $HOME/.config/nvim/tmp/backup
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
]])
