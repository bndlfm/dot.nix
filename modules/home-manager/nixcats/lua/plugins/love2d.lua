-- using lazy.nvim
return {
  {
    "S1M0N38/love2d.nvim",
    cmd = "LoveRun",
    opts = {},
    keys = {
      { "<leader>v", desc = "LÖVE" },
      { "<leader>vv", "<cmd>LoveRun<cr>", desc = "Run LÖVE" },
      { "<leader>vs", "<cmd>LoveStop<cr>", desc = "Stop LÖVE" },
    },
  },
}
