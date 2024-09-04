return {
  --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--
  --  WARNING: THIS IS A LOAD BEARING  --
  --  OPT DICTIONARY THINGY AND BREAKS --
  --  LOADING KEYMAPS FOR SOME REASON  --
  --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--
  {
    --"ellisonleao/gruvbox.nvim",
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nordic",
    },
  },
  --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--
  --  END OF LOAD BEARING THEME SETUP  --
  --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--

  {
    "folke/trouble.nvim",
    enabled = true,
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = {
      mappings = {
        -- Main textobject prefixes
        around = "a",
        inside = "k",
        -- Next/last variants
        around_next = "an",
        inside_next = "kn",
        around_last = "al",
        inside_last = "kl",
        -- Move cursor to corresponding edge of `a` textobject
        goto_left = "g[",
        goto_right = "g]",
      },
      -- Number of lines within which textobject is searched
      n_lines = 500,
      -- Whether to disable showing non-error feedback
      silent = false,
    },
  },

  {
    "echasnovski/mini.indentscope",
    enabled = true,
    event = "VeryLazy",
    opts = {
      mappings = {
        -- Textobjects
        object_scope = "kk",
        object_scope_with_border = "ak",
        -- Motions (jump to respective border line; if not present - body line)
        goto_top = "[k",
        goto_bottom = "]k",
      },
      options = {
        -- Whether to use cursor column when computing reference indent.
        -- Useful to see incremental scopes with horizontal cursor movements.
        indent_at_cursor = true,
      },
    },
  },
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },
}
