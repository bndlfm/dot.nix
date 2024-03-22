-- override nvim-cmp and add cmp-emoji
return {
  "hrsh7th/nvim-cmp",
  priority = 50,
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-emoji",
    "onsails/lspkind.nvim",
  },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")
    local lspkind = require("lspkind")
    local kind_icons = {
      Text = "",
      Method = "󰆧",
      Function = "󰊕",
      Constructor = "",
      Field = "󰇽",
      Variable = "󰂡",
      Class = "󰠱",
      Interface = "",
      Module = "",
      Property = "󰜢",
      Unit = "",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰏿",
      Struct = "",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "󰅲",
    }
    opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
      { name = "nvim_lsp" },
      { name = "codeium" },
      { name = "emoji" },
      { name = "crates" },
    }))
    cmp.setup({
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
          local strings = vim.split(kind.kind, "%s", { trimempty = true })
          kind.kind = " " .. (strings[1] or "") .. " "
          kind.menu = "    (" .. (strings[2] or "") .. ")"

          return kind
        end,
      },
    })
  end,
},
{
  "hrsh7th/cmp-nvim-lsp",
  -- override nvim-cmp source for neovim's native LSP
  -- cmp sources for neovim's LSP
  enabled = true,
},
-- Use <tab> for completion and snippets (supertab)
-- first: disable default <tab> and <s-tab> behavior in LuaSnip
{
  "L3MON4D3/LuaSnip",
  keys = function()
    return {}
  end,
},
--+++ then: setup supertab in cmp
{
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-emoji",
    "onsails/lspkind.nvim",
  },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local luasnip = require("luasnip")
    local cmp = require("cmp")

    opts.mapping = vim.tbl_extend("force", opts.mapping, {
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
        -- this way you will only jump inside the snippet region
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<CR>"] = cmp.config.disable,
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<C-y>"] = cmp.mapping.confirm(),
    })
  end,
}
