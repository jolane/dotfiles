vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.opt.clipboard = "unnamedplus"
vim.wo.number = true

-- Setup lazy.nvim
require("config.lazy")
require("config.lsp")
require("config.filetypes")

vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })
