return {
  "timtro/glslView-nvim",
  enabled = false,
  event = "VeryLazy",
  ft = "glsl",
  config = function()
    require("glslView").setup({
      viewer_path = "glslViewer",
      args = { "-l" },
    })
  end,
}
