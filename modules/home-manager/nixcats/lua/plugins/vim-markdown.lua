return {
  "preservim/vim-markdown",
  dependencies = { "godlygeek/tabular" },
  config = function()
    vim.g.vmt_cycle_list_item_markers = 1
    vim.g.vmt_fence_text = "TOC"
    vim.g.vmt_fence_closing_text = "/TOC"
  end,
}
