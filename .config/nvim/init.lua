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
