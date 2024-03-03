return {
  "mg979/vim-visual-multi",
  enabled = true,
  event = "VeryLazy",
  keys = {
    vim.keymap.set({ "n", "v" }, "<LEADER>m", "<CMD>VMLive<CR>", { desc = "Starts Visual-Multi" }),
  },
  config = function()
    vim.g.VM_theme = "iceblue"
    vim.g.VM_leader = {
      default = ",",
      visual = ",",
      buffer = ",",
    }
    vim.g.VM_custom_motions = {
      h = "h",
      i = "l",
      e = "k",
      n = "j",
      H = "0",
      I = "$",
      l = "i",
    }
    vim.g.VM_maps = {}
    vim.g.VM_maps = {
      ["i"] = "k",
      ["I"] = "K",
      ["Find Under"] = "<C-k>",
      ["Find Subword Under"] = "<C-k>",
      ["Find Next"] = "",
      ["Find Prev"] = "",
      ["Remove Region"] = "q",
      ["Skip Region"] = "<C-n>",
      ["Undo"] = "u",
      ["Redo"] = "<C-r>",
    }
  end,
}
