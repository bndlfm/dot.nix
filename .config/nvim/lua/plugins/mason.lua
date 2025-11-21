return {
  "mason-org/mason.nvim",
  enabled = true,
  opts = {
    ensure_installed = {
      "lua-language-server",
      "stylua",
      "shellcheck",
      "shfmt",
      "flake8",
      "codelldb",
    },
  },
}
