return {
  "smoka7/multicursors.nvim",
  enabled = false,
  event = "VeryLazy",
  dependencies = {
    "smoka7/hydra.nvim",
  },
  cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
  keys = {
    {
      mode = { "v", "n" },
      "<LEADER>m",
      "<CMD>MCstart<CR>",
      desc = "Multi-cursor selection under cursor",
    },
  },
  opts = {},
  config = function()
    require("multicursors").setup({
      mode_keys = {
        append = "a",
        change = "c",
        extend = "x",
        insert = "k",
      },
      normal_keys = {
        ["n"] = {
          method = false,
        },
        ["e"] = {
          method = false,
        },
        ["i"] = {
          method = false,
        },
        ["<DOWN>"] = {
          method = require("multicursors.normal_mode").create_down,
          opts = { desc = "Create selection ⇩" },
        },
        ["<UP>"] = {
          method = require("multicursors.normal_mode").create_up,
          opts = { desc = "Create selection ⇧" },
        },
      },
      extend_keys = {
        ["n"] = {
          method = false,
        },
        ["e"] = {
          method = false,
        },
        ["i"] = {
          method = false,
        },

        --        ["x"] = {
        --          method = require("multicursors.extend_mode").e_method,
        --        },
        --        ["e"] = {
        --          method = require("multicursors.normal_mode").create_up,
        --          opts = { desc = "Create selection ⇧" },
        --        },
      },
    })
  end,
}
