require("config.options")
require("config.keymaps")
require("config.autocmds")
require("plugins.editor")
require("plugins.lsp")
-- Enable autoread globally
vim.opt.autoread = true

-- Create an autocommand to trigger checktime on specific events
-- vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
--   pattern = "*",
--   callback = function()
--     if vim.fn.mode() ~= 'c' then
--       vim.cmd("checktime")
--     end
--   end,
-- })
