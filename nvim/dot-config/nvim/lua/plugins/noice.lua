return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
    },
  },
  keys = {
    { "<leader>sn", "", desc = "+noice" },
    {
      "<S-Enter>",
      function()
        require("noice").redirect(vim.fn.getcmdline())
      end,
      mode = "c",
      desc = "Redirect cmdline",
    },
    {
      "<leader>snl",
      function()
        require("noice").cmd("last")
      end,
      desc = "Noice last message",
    },
    {
      "<leader>snh",
      function()
        require("noice").cmd("history")
      end,
      desc = "Noice history",
    },
    {
      "<leader>sna",
      function()
        require("noice").cmd("all")
      end,
      desc = "Noice all",
    },
    {
      "<leader>snd",
      function()
        require("noice").cmd("dismiss")
      end,
      desc = "Dismiss all",
    },
    {
      "<leader>snt",
      function()
        require("noice").cmd("pick")
      end,
      desc = "Noice picker",
    },
    {
      "<C-f>",
      function()
        if not require("noice.lsp").scroll(4) then
          return "<C-f>"
        end
      end,
      silent = true,
      expr = true,
      mode = { "i", "n", "s" },
      desc = "Scroll forward",
    },
    {
      "<C-b>",
      function()
        if not require("noice.lsp").scroll(-4) then
          return "<C-b>"
        end
      end,
      silent = true,
      expr = true,
      mode = { "i", "n", "s" },
      desc = "Scroll backward",
    },
  },
  config = function(_, opts)
    if vim.o.filetype == "lazy" then
      vim.cmd("messages clear")
    end

    require("noice").setup(opts)
  end,
}
