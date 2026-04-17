return {
  "folke/trouble.nvim",
  cmd = { "Trouble" },
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
    { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols" },
    { "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP lists" },
    { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
    { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
    {
      "[q",
      function()
        if require("trouble").is_open() then
          require("trouble").prev({ skip_groups = true, jump = true })
        else
          vim.cmd.cprev()
        end
      end,
      desc = "Prev trouble/quickfix item",
    },
    {
      "]q",
      function()
        if require("trouble").is_open() then
          require("trouble").next({ skip_groups = true, jump = true })
        else
          vim.cmd.cnext()
        end
      end,
      desc = "Next trouble/quickfix item",
    },
  },
  opts = {
    modes = {
      lsp = {
        win = { position = "right" },
      },
    },
  },
}
