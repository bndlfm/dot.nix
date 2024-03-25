return {
  "williamboman/mason.nvim",
  enable = false,
  opts = {
    ensure_installed = {
      "nil_ls",
      "lua-language-server",
      "stylua",
      "shellcheck",
      "shfmt",
      "flake8",
      "codelldb",
    },
  },
}
