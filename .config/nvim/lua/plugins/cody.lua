return {
  {
    "sourcegraph/sg.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },

    build = "nvim -l build/init.lua",
    config = function()
      require("sg").setup({})
    end,
  },
}
