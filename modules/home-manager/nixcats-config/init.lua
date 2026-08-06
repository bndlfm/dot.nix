-- Initialize nixCats
-- This is provided by the nixCats wrapper.
-- If not running via nixCats, we provide a fallback.
if not pcall(require, "nixCats") then
  _G.nixCats = function(name)
    if name == nil then
      return {
        isNixCats = false,
        pawsible = {
          all_plugins = {},
          plugin_dir = vim.fn.stdpath("data") .. "/site/pack/packer/start",
          all_plugins_patterns = {},
        },
      }
    end
    return nil
  end
end

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

if vim.g.started_by_firenvim == true then
  require("config.lazy")
else
  require("config.lazy")
end
