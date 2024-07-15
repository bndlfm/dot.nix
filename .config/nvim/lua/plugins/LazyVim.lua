return {
  --"ellisonleao/gruvbox.nvim",
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nordic",
    },
  },

  -- change trouble config
  {
    "folke/trouble.nvim",
    enabled = true,
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
  -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
  --{ import = "lazyvim.plugins.extras.lang.typescript" },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        options = {
          theme = "nordic",
        },
      }
    end,
  },

  -- use mini.starter instead of alpha
  --  { import = "lazyvim.plugins.extras.ui.mini-starter" },

  -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  --  { import = "lazyvim.plugins.extras.lang.json" },

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
}
