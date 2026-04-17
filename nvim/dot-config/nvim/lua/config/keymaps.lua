local map = vim.keymap.set

map("i", "jj", "<Esc>", { desc = "Escape insert mode" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map({ "n", "i", "x", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

map("n", "<leader>-", "<C-w>s", { desc = "Split window below" })
map("n", "<leader>|", "<C-w>v", { desc = "Split window right" })
map("n", "<leader>wd", "<C-w>c", { desc = "Delete window" })
