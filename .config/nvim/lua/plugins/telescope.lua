return {
  "nvim-telescope/telescope.nvim",

  dependencies = {
    "debugloop/telescope-undo",
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    {},
  },

  keys = {
    -- stylua: ignore
    {
      "<leader>fp",
      function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
      desc = "Find Plugin File",
    },
    {
      "<LEADER>fu",
      "<CMD>Telescope undo<CR>",
      desc = "Find in Undo History",
    },
  },

  opts = {
    defaults = {
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      winblend = 0,
    },
  },

  config = function()
    require("telescope").setup({
      extensions = {
        undo = {
          -- telescope-undo.nvim config, see below
        },
      },
    })
    require("telescope").load_extension("undo")
  end,
}
