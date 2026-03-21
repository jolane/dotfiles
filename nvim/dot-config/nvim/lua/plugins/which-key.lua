return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    layout = {
      align = "right",
      spacing = 3
    },
    win = {
      border = "rounded",
      width = 40,
      row = math.floor((vim.o.lines - 50) / 2),
      col = vim.o.columns,
    },
  },
}
