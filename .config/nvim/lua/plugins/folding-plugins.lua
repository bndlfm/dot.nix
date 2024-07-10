local foldIcon = ""
local hlgroup = "NonText"
local function foldTextFormatter(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = "  " .. foldIcon .. "  " .. tostring(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, hlgroup })
  return newVirtText
end

--------------------------------------------------------------------------------

return {
  {
    "chrisgrieser/nvim-origami",
    enabled = true,
    event = "BufReadPost", -- later will not save folds
    opts = true,
  },
  { -- UFO
    "kevinhwang91/nvim-ufo",
    enabled = true,
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost", -- needed for folds to load in time
    keys = {
      {
        "zr",
        function()
          require("ufo").openFoldsExceptKinds({ "comment" })
        end,
        desc = " 󱃄 Open All Folds except comments",
      },
      {
        "zm",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = " 󱃄 Close All Folds",
      },
      {
        "z1",
        function()
          require("ufo").closeFoldsWith(1)
        end,
        desc = " 󱃄 Close L1 Folds",
      },
      {
        "z2",
        function()
          require("ufo").closeFoldsWith(2)
        end,
        desc = " 󱃄 Close L2 Folds",
      },
      {
        "z3",
        function()
          require("ufo").closeFoldsWith(3)
        end,
        desc = " 󱃄 Close L3 Folds",
      },
      {
        "z4",
        function()
          require("ufo").closeFoldsWith(4)
        end,
        desc = " 󱃄 Close L4 Folds",
      },
      {
        "z5",
        function()
          require("ufo").closeFoldsWith(5)
        end,
        desc = " 󱃄 Close L1 Folds",
      },
      {
        "z6",
        function()
          require("ufo").closeFoldsWith(6)
        end,
        desc = " 󱃄 Close L6 Folds",
      },
      {
        "z7",
        function()
          require("ufo").closeFoldsWith(7)
        end,
        desc = " 󱃄 Close L7 Folds",
      },
      {
        "z8",
        function()
          require("ufo").closeFoldsWith(8)
        end,
        desc = " 󱃄 Close L8 Folds",
      },
    },
    init = function()
      -- Fold commands usually change the foldlevel, which fixes folds, e.g. auto-closing after
      -- leaving insert mode, ufo does not have equivalents for zr and zm because there is no
      -- saved fold level.  vim-internal fold levels need to be disabled by setting to 99
      vim.opt.foldenable = true
      vim.opt.foldcolumn = "1"
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99

      require("ufo").setup(opts)
    end,
    opts = {
      -- Hide closing }]) in fold with treesitter
      enable_get_fold_virt_text = true,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate, ctx)
        -- include the bottom line in folded text for additional context
        local filling = " ⋯ "
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        table.insert(virtText, { filling, "Folded" })
        local endVirtText = ctx.get_fold_virt_text(endLnum)
        for i, chunk in ipairs(endVirtText) do
          local chunkText = chunk[1]
          local hlGroup = chunk[2]
          if i == 1 then
            chunkText = chunkText:gsub("^%s+", "")
          end
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(virtText, { chunkText, hlGroup })
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            table.insert(virtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        return virtText
      end,

      close_folds_kinds_for_ft = {
        default = { "imports", "comment" },
        json = { "array" },
        c = { "comment", "region" },
      },

      open_fold_hl_timeout = 800,

      preview = {},

      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    },
  },
}
