return {
  {
    "glacambre/firenvim",
    enabled = true,
    build = function()
      vim.fn["firenvim#install"](0)
    end,
    cond = not not vim.g.started_by_firenvim,
  },
}
