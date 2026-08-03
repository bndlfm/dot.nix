return {
  "nhu/patchr.nvim",
  ---@type patchr.config
  opts = {
    ["snacks.nvim"] = {
      vim.fs.joinpath(vim.fn.stdpath("config"), "patches", "snacksScope.patch"),
    },
  },
}
