return {
  "vhyrro/luarocks.nvim",
  enabled = false,
  priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
  config = true,
  opts = {
    rocks = {
      "image.nvim",
      "magick",
    },
  },
}
