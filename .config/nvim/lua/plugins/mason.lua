return {
  "williamboman/mason.nvim",
  enable = false,
  opts = {
    ensure_installed = {
      "nil",
      "lua-language-server",
      "stylua",
      "shellcheck",
      "shfmt",
      "flake8",
      "codelldb",
    },
  },
}
