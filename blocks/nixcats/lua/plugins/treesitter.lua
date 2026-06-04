return -- add more treesitter parsers
{
  "nvim-treesitter/nvim-treesitter",
  depends = { "luckasRanarison/tree-sitter-hypr" },
  opts = {
    ensure_installed = {
      "bash",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "ron",
      "rust",
      "tsx",
      "toml",
      "typescript",
      "vim",
      "yaml",
      "norg",
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { "markdown" },
    },
    --config = function()
    --  require("nvim-treesitter.parsers").get_parser_configs().hypr = {
    --    install_info = {
    --      url = "https://github.com/luckasRanarison/tree-sitter-hypr",
    --      files = { "src/parser.c" },
    --      branch = "master",
    --    },
    --  }
    --end,
    --filetype = "hypr",
  },
}
