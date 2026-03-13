return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "vimdoc",
      "go",
      "javascript",
      "typescript",
      "tsx",
      "json",
      "bash",
      "markdown",
    },
    highlight = { enable = true },
    indent = { enable = true },
  }
}
