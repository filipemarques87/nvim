local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Tab switching
-- map("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
-- map("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })
-- map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
-- map("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Go to different windows
-- map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
-- map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
-- map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
-- map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Close current buffer
map("n", "<leader>q", "<cmd>bp<bar>bd #<cr>")

-- Resize windows
map("n", "<leader>ww", "<C-w>p", { desc = "Other Window", remap = true })
map("n", "<leader>wd", "<C-w>c", { desc = "Delete Window", remap = true })
-- map("n", "<leader>sh", "<C-W>s", { desc = "Split Window Below", remap = true })
-- map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
-- map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
-- map("n", "<leader>`", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>sv", "<C-W>v", { desc = "Split Window Right", remap = true })

-- tabs
-- map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
-- map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
-- map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
-- map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
-- map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
-- map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
-- map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
-- ------------------------------------------------------------------------- }}}

-- Close all fold except the current one.
-- map("n", "zv", "zMzvzz", {
-- desc = "Close all folds except the current one",
-- })

-- Close current fold when open. Always open next fold.
-- map("n", "zj", "zcjzOzz", {
-- desc = "Close current fold when open. Always open next fold.",
-- })

-- Close current fold when open. Always open previous fold.
-- map("n", "zk", "zckzOzz", {
-- desc = "Close current fold when open. Always open previous fold.",
-- })

-- Better paste
-- remap "p" in visual mode to delete the highlighted text without overwriting your yanked/copied text, and then paste the content from the unnamed register.
-- map("v", "p", '"_dP', opts)

-- Copy whole file content to clipboard with C-c
-- map("n", "<C-c>", ":%y+<CR>", opts)

-- Select all text in buffer with Alt-a
-- map("n", "<A-a>", "ggVG", { noremap = true, silent = true, desc = "Select all" })

-- Visual --
-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Easier access to beginning and end of lines
-- map("n", "<A-h>", "^", { desc = "Go to start of line", silent = true, })
-- map("n", "<A-l>", "$", { desc = "Go to end of line", silent = true, })

-- Move live up or down
-- moving
map("n", "<A-Down>", ":m .+1<CR>", opts)
map("n", "<A-Up>", ":m .-2<CR>", opts)
map("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", opts)
map("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", opts)
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", opts)

-- Fix Spell checking
-- map("n", "z0", "1z=", {
-- desc = "Fix world under cursor",
-- })

-- Toggle wrap
-- map("n", "<leader>tw", "<cmd>set wrap!<CR>", {
-- desc = "Toggle Wrap",
-- silent = true,
-- })

-- map("n", "<leader>us", function()
--   local current_state = vim.o.spell
--   local bufnr = vim.api.nvim_get_current_buf()
--
--   if current_state then
--     local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "harper_ls" })
--     for _, client in ipairs(clients) do
--       client:stop()
--     end
--     vim.o.spell = false
--     vim.notify("Disabled Spell + Harper")
--   else
--     vim.o.spell = true
--     vim.lsp.enable("harper_ls", bufnr)
--     vim.notify("Enabled Spell + Harper")
--   end
-- end, { desc = "Toggle Spell + Harper" })

-- auto close pairs
-- map("i", "'", "''<left>")
-- map("i", "`", "``<left>")
-- map("i", '"', '""<left>')
-- map("i", "(", "()<left>")
-- map("i", "[", "[]<left>")
-- map("i", "{", "{}<left>")
-- map("i", "<", "<><left>")

-- vim.pack keymaps  (<leader>p = pack)
-- map("n", "<leader>pp", "<cmd>Pack<cr>", { desc = "Pack UI" })
-- map("n", "<leader>pu", "<cmd>lua vim.pack.update()<cr>", { desc = "Pack Update All" })
-- map("n", "<leader>pd", function()
-- vim.ui.input({ prompt = "Plugin name to delete: " }, function(input)
-- if input and input ~= "" then
-- pcall(vim.pack.del, { input })
-- end
-- end)
-- end, { desc = "Pack Delete" })

-- map("n", "<leader>R", function()
-- 	local session = vim.fn.stdpath("state") .. "/restart_session.vim"
-- 	vim.cmd("mksession! " .. vim.fn.fnameescape(session))
-- 	vim.cmd("restart source " .. vim.fn.fnameescape(session))
-- end, { desc = "Restart Neovim" })

-- delete marks (use m + character for a mark)
-- vim.keymap.set("n", "dm", function()
-- local mark = vim.fn.getcharstr()
-- vim.cmd("delmarks " .. mark)
-- end, { desc = "Delete mark" })
