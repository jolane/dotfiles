return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    local lazy_status = require("lazy.status")

    require("lualine").setup({
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = {
          statusline = { "startup", "dashboard" },
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = "󰅚 ",
              warn = "󰀪 ",
              info = "󰋽 ",
              hint = "󰌶 ",
            },
          },
          { "filename", path = 1 },
        },
        lualine_x = {
          {
            function()
              return require("noice").api.status.command.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.command.has()
            end,
          },
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
          },
          {
            "diff",
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_y = {
          { "filetype", icon_only = false },
          "progress",
        },
        lualine_z = { "location" },
      },
      extensions = { "neo-tree", "lazy" },
    })
  end,
}
