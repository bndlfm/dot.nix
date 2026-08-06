-- Bridge lazy.nvim with nixCats using the lazyCat wrapper
require('nixCatsUtils').setup { non_nix_value = true }
local nixCats = require('nixCats')

local lazyOptions = {
  lockfile = (nixCats.settings.unwrappedCfgPath or nixCats.settings.nixCats_config_location) .. '/lazy-lock.json',
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘', config = '🛠', event = '📅', ft = '📂', init = '⚙',
      keys = '🗝', plugin = '🔌', runtime = '💻', require = '🌙',
      source = '📄', start = '🚀', task = '📌', lazy = '💤 ',
    },
  },
  checker = { enabled = not nixCats.isNixCats },
  performance = {
    rtp = { disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" } },
  },
  -- nixCats bridge for dev plugins
  dev = {
    path = function(plugin)
      return nixCats.pawsible({ "allPlugins", "opt", plugin.name })
          or nixCats.pawsible({ "allPlugins", "start", plugin.name })
    end,
    patterns = { "" },
    fallback = true,
  },
}

-- lazyCat wrapper: first arg = nix-provided lazy.nvim path, second = spec, third = options
require('nixCatsUtils.lazyCat').setup(
  nixCats.pawsible { 'allPlugins', 'start', 'lazy.nvim' },
  {
    spec = {
      { "LazyVim/LazyVim", import = "lazyvim.plugins" },
      { import = "lazyvim.plugins.extras.lang.nix" },
      { import = "plugins" },
    },
    defaults = { lazy = false, version = false },
  },
  lazyOptions
)