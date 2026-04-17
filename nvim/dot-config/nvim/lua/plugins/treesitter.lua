return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    local languages = {
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
    }

    ts.setup({})
    ts.install(languages)

    local highlight_group = vim.api.nvim_create_augroup("user_treesitter_start", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = highlight_group,
      pattern = {
        "lua",
        "vim",
        "help",
        "go",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "json",
        "sh",
        "bash",
        "markdown",
      },
      callback = function(event)
        pcall(vim.treesitter.start, event.buf)
      end,
    })

    local indent_group = vim.api.nvim_create_augroup("user_treesitter_indent", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = indent_group,
      pattern = {
        "lua",
        "go",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "json",
        "sh",
        "bash",
      },
      callback = function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
