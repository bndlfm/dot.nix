return {
  "Saecki/crates.nvim",
  enabled = false,
  event = { "BufRead Cargo.toml" },
  opts = {
    src = {
      cmp = { enabled = true },
    },
  },
}
