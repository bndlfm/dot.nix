return {
  "AlexvZyl/nordic.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local palette = require("nordic.colors")
    require("nordic").setup({
      -- This callback can be used to override the colors used in the palette.
      on_palette = function(palette)
        return palette
      end,
      bold_keywords = true,
      italic_comments = true,
      transparent_bg = false,
      -- Enable brighter float border.
      bright_border = false,
      reduced_blue = true,
      -- Swap the dark background with the normal one.
      swap_backgrounds = false,
      -- Override the styling of any highlight group.
      override = {
        Visual = {
          bg = palette.gray2,
        },
      },
      -- Cursorline options.  Also includes visual/selection.
      cursorline = {
        bold = true,
        bold_number = true,
        theme = "light",
        blend = 0.85,
      },
      noice = {
        -- Available styles: `classic`, `flat`.
        style = "classic",
      },
      telescope = {
        -- Available styles: `classic`, `flat`.
        style = "flat",
      },
      leap = {
        -- Dims the backdrop when using leap.
        dim_backdrop = true,
      },
      ts_context = {
        -- Enables dark background for treesitter-context window
        dark_background = true,
      },
    })
  end,
}
