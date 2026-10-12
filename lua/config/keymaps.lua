local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Close current buffer
map("n", "<leader>q", "<cmd>bp<bar>bd #<cr>", { desc = "Close buffer" })

-- Windows
map("n", "<leader>ww", "<C-w>p", { desc = "Other Window", remap = true })
map("n", "<leader>wd", "<C-w>c", { desc = "Delete Window", remap = true })
map("n", "<leader>sv", "<C-W>v", { desc = "Split Window Right", remap = true })

-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move line up or down
map("n", "<A-Down>", ":m .+1<CR>", opts)
map("n", "<A-Up>", ":m .-2<CR>", opts)
map("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", opts)
map("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", opts)
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", opts)
