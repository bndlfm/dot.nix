-- override nvim-cmp and add cmp-emoji
return {
  "hrsh7th/nvim-cmp",
  enabled = false,
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
    cmp.setup({
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "cody" },
        { name = "buffer" },
        { name = "emoji" },
        { name = "crates" },
      }),
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = lspkind.cmp_format({
          menu = {
            nvim_lsp = "[LSP]",
            cody = "[CODY]",
            buffer = "[Buffer]",
            emoji = "[Emoji]",
            crates = "[Crates]",
          },
        }),
      },
    })
  end,
}
