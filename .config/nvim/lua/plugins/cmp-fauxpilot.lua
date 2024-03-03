return {
  "nzlov/cmp-fauxpilot",
  enabled = false,
  dependencies = "hrsh7th/nvim-cmp",
  config = function()
    require("cmp_fauxpilot.config").setup({
      host = "http://localhost:5000",
      model = "py-model",
      max_tokens = 100,
      max_lines = 1000,
      max_num_results = 4,
      temperature = 0.6,
    })
  end,
}
