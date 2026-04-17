return {
  "folke/todo-comments.nvim",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TodoTrouble", "TodoTelescope" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
  keys = {
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next todo comment",
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Prev todo comment",
    },
    { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo" },
    { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme" },
    { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
  },
}
