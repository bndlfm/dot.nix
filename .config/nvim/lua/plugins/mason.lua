return {
  "williamboman/mason.nvim",
  enabled = true,
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
