-- NOTE: OLD
-- bootstrap lazy.nvim, LazyVim and your plugins
if vim.g.started_by_firenvim == true then
  require("config.lazy")
else
  require("config.lazy")
end

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.hypr = {
  install_info = {
    url = "https://github.com/luckasRanarison/tree-sitter-hypr",
    files = { "src/parser.c" },
    branch = "master",
  },
  filetype = "hypr",
}

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local package_path = vim.fn.stdpath("data") .. "/lazy"

function ensure(repo, package, dir)
  if not dir then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--single-branch",
      "https://github.com/" .. repo .. ".git",
      package_path .. "/" .. package,
    })
    vim.opt.runtimepath:prepend(package_path .. "/" .. package)
  else
    local install_path = string.format("%s/%s", package_path, package)
    vim.fn.system(string.format("rm -r %s", install_path))
    vim.fn.system(string.format("ln -s %s %s", repo, package_path))
    vim.opt.runtimepath:prepend(install_path)
  end
end

vim.opt.runtimepath:prepend(lazy_path)
