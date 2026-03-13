return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", -- optional, but recommended
  },
  lazy = false, -- neo-tree will lazily load itself
  opts = {
    filesystem = {
      filtered_items = {
        visible = false, -- hide filtered items on open
        hide_gitignored = true,
        hide_dotfiles = false,
        hide_by_name = {
          ".github",
          ".gitignore",
          "package-lock.json",
          ".changeset",
          ".prettierrc.json",
        },
        never_show = { ".git" },
      },
    },
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)
    vim.keymap.set('n', '<leader>e', ':Neotree filesystem reveal left<CR>', {})
  end
}
