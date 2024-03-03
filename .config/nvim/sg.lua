return {
  {
    "sourcegraph/sg.nvim",
    enable = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("sg").setup({
        auth_strategy = {
          "environment-variables",
        },
        enable_cody = true,
        download_binaries = true,
      })
    end,
  },
}
