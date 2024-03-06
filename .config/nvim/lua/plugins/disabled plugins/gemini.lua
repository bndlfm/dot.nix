return {
  "kiddos/gemini.nvim",
  enabled = false,
  build = { "pip install -r requirements.txt", ":UpdateRemotePlugins" },
  config = function()
    require("gemini").setup()
  end,
}
