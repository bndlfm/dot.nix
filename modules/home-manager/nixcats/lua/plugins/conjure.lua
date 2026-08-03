return {
  {
    "Olical/conjure",
    enabled = false,
    ft = { "clojure", "fennel", "python" }, -- etc
    lazy = true,

    -- Optional cmp-conjure integration
    dependencies = { "PaterJason/cmp-conjure" },

    config = function()
      require("conjure.main").main()
      require("conjure.mapping")["on-filetype"]()
    end,
    init = function()
      -- Set configuration options here
      vim.g["conjure#debug"] = true
    end,
  },
  {
    "PaterJason/cmp-conjure",
    enabled = true,
    lazy = true,
  },
}
