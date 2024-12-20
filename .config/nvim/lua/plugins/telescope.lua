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
      "<leader>u",
      "<CMD>Telescope undo<CR>",
      desc = "Find in Undo History",
    },
  },

  opts = {
    defaults = {
      side_by_side = true,
      layout_strategy = "vertical",
      layout_config = { preview_width = 0.8 },
      sorting_strategy = "ascending",
      winblend = 0,
    },
  },

  config = function()
    require("telescope").setup({
      extensions = {
        undo = {
          i = {
            ["<cr>"] = require("telescope-undo.actions").yank_additions,
            ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
            ["<C-cr>"] = require("telescope-undo.actions").restore,
            -- alternative defaults, for users whose terminals do questionable things with modified <cr>
            ["<C-y>"] = require("telescope-undo.actions").yank_deletions,
            ["<C-r>"] = require("telescope-undo.actions").restore,
          },
          n = {
            ["y"] = require("telescope-undo.actions").yank_additions,
            ["Y"] = require("telescope-undo.actions").yank_deletions,
            ["u"] = require("telescope-undo.actions").restore,
          },
        },
      },
    })
    require("telescope").load_extension("undo")
  end,
}
