local spec = {
  -- Default when not invoked by the browser addon
  "glacambre/firenvim",
  build = function()
    vim.fn["firenvim#install"](0)
  end,
  module = false, -- prevent other code from requiring("firenvim")
  lazy = true, -- never load except when lazy.nvim is building the plugin
}

if vim.g.started_by_firenvim == true then
  -- Inside browser via Firenvim
  spec = {
    { "noice.nvim", cond = false }, -- breaks with GUI ext_cmdline
    { "lualine.nvim", cond = false }, -- not useful in browser

    vim.tbl_extend("force", spec, {
      lazy = false,
      opts = {
        localSettings = {
          [".*"] = {
            -- Tip: In Firefox, set Manage Extension Shortcuts -> ctrl-6
            -- because GitHub's markdown editor uses ctrl-e
            takeover = "never", -- security: activate manually with ctrl-e
            cmdline = "neovim", -- instead of "firenvim"
          },
        },
      },
      config = function(_, opts)
        if type(opts) == "table" and (opts.localSettings or opts.globalSettings) then
          vim.g.firenvim_config = opts
        end
      end,
    }),
  }
end

return spec
