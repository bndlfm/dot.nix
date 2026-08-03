return {
  "GCBallesteros/NotebookNavigator.nvim",
  keys = {
    {
      "]h",
      function()
        require("notebook-navigator").move_cell("d")
      end,
    },
    {
      "[h",
      function()
        require("notebook-navigator").move_cell("u")
      end,
    },
    { "<leader>X", "<cmd>lua require('notebook-navigator').run_cell()<cr>" },
    { "<leader>x", "<cmd>lua require('notebook-navigator').run_and_move()<cr>" },
  },
  dependencies = {
    "echasnovski/mini.comment",
    "hkupty/iron.nvim", -- repl provider
    -- or "akinsho/toggleterm.nvim" -- repl provider
    "smoka7/hydra.nvim",
  },
  event = "VeryLazy",
  config = function()
    local nn = require("notebook-navigator")
    local ai = require("mini.ai")
    nn.setup({ activate_hydra_keys = "<leader>h" })
    ai.setup({
      custom_textobjects = {
        h = nn.miniai_spec,
      },
    })
  end,
}
