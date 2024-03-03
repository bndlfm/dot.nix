return {
  "kevinhwang91/rnvimr",
  enabled = false,
  config = function()
    vim.g.rnvimr_ex_enable = 1
    vim.g.rnvimr_pick_enable = 1
    vim.g.rnvimr_draw_border = 0
    --let g:rnvimr_bw_enable = 1
    vim.cmd([[highlight link RnvimrNormal CursorLine]])
    vim.keymap.set(
      "n",
      "<LEADER>R",
      ":RnvimrToggle<CR><C-\\><C-n>:RnvimrResize 0<CR>",
      { desc = "Toggle Ranger", silent = true, remap = false }
    )
    vim.g.rnvimr_action = {
      ["<C-t>"] = "NvimEdit tabedit",
      ["<C-x>"] = "NvimEdit split",
      ["<C-v>"] = "NvimEdit vsplit",
      gw = "JumpNvimCwd",
      yw = "EmitRangerCwd",
    }
    vim.g.rnvimr_layout = {
      relative = "editor",
      width = vim.o.columns,
      height = vim.o.lines,
      col = 0,
      row = 0,
      style = "minimal",
    }
    vim.g.rnvimr_presets = {
      width = 1.0,
      height = 1.0,
    }
  end,
}
