return {
  "epwalsh/obsidian.nvim",
  enabled = true,
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
    {
      "oflisback/obsidian-bridge.nvim",
      config = function()
        require("obsidian-bridge").setup()
      end,
      lazy = false,
    },
  },
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/Notes/**.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/Notes/**.md",
  },
  opts = {
    dir = "~/Notes", -- no need to call 'vim.fn.expand' here
  },
}
