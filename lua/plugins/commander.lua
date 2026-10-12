-- command palette: <leader>fc
vim.pack.add({ "https://github.com/FeiyouG/commander.nvim" })

local commander = require("commander")

commander.setup({
	components = { "DESC", "KEYS", "CAT" },
	sort_by = { "CAT", "DESC" },
	integration = {
		telescope = { enable = true },
	},
})

local function copy(expr)
	return function()
		local value = vim.fn.expand(expr)
		vim.fn.setreg("+", value)
		vim.notify("Copied: " .. value)
	end
end

local function toggle(option)
	return function()
		vim.opt_local[option] = not vim.opt_local[option]:get()
		vim.notify(option .. ": " .. tostring(vim.opt_local[option]:get()))
	end
end

-- deletes every listed buffer except the current one; skips buffers with unsaved changes
local function close_other_buffers()
	local current = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= current and vim.bo[buf].buflisted then
			pcall(vim.api.nvim_buf_delete, buf, {})
		end
	end
end

commander.add({
	{ desc = "Open command palette", cmd = commander.show, keys = { "n", "<leader>fc" } },
})

commander.add({
	{ desc = "Close buffer", cmd = "<cmd>bp|bd #<cr>", keys = { "n", "<leader>q" }, set = false },
	{ desc = "Close other buffers", cmd = close_other_buffers },
	{ desc = "Close all buffers", cmd = "<cmd>%bd<cr>" },
	{ desc = "Save all buffers", cmd = "<cmd>wa<cr>" },
	{ desc = "Reload file from disk (discard changes)", cmd = "<cmd>e!<cr>" },
}, { cat = "buffer" })

commander.add({
	{ desc = "Restart LSP", cmd = "<cmd>lsp restart<cr>" },
	{ desc = "Stop LSP", cmd = "<cmd>lsp stop<cr>" },
	{ desc = "LSP health check", cmd = "<cmd>checkhealth vim.lsp<cr>" },
	{
		desc = "Open LSP log",
		cmd = function()
			vim.cmd.tabnew(vim.lsp.log.get_filename())
		end,
	},
	{
		desc = "Toggle inlay hints",
		cmd = function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
		end,
	},
	-- already mapped elsewhere; listed here as a cheat sheet
	{ desc = "Go to definition", cmd = vim.lsp.buf.definition, keys = { "n", "gd" }, set = false },
	{ desc = "Go to declaration", cmd = vim.lsp.buf.declaration, keys = { "n", "gdd" }, set = false },
	{ desc = "Go to implementation", cmd = vim.lsp.buf.implementation, keys = { "n", "gri" }, set = false },
	{ desc = "Go to type definition", cmd = vim.lsp.buf.type_definition, keys = { "n", "grt" }, set = false },
	{ desc = "References", cmd = vim.lsp.buf.references, keys = { "n", "grr" }, set = false },
	{ desc = "Rename symbol", cmd = vim.lsp.buf.rename, keys = { "n", "grn" }, set = false },
	{ desc = "Code action", cmd = vim.lsp.buf.code_action, keys = { "n", "gra" }, set = false },
	{ desc = "Document symbols", cmd = "<cmd>Telescope lsp_document_symbols<cr>", keys = { "n", "gO" }, set = false },
	{ desc = "Workspace symbols", cmd = "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>" },
	{ desc = "Format file", cmd = "<cmd>lua require('conform').format({ lsp_fallback = true })<cr>", keys = { "n", "grf" }, set = false },
}, { cat = "lsp" })

commander.add({
	{
		desc = "Next diagnostic",
		cmd = function()
			vim.diagnostic.jump({ count = 1 })
		end,
		keys = { "n", "gdn" },
		set = false,
	},
	{
		desc = "Previous diagnostic",
		cmd = function()
			vim.diagnostic.jump({ count = -1 })
		end,
		keys = { "n", "gdp" },
		set = false,
	},
	{ desc = "Show diagnostic under cursor", cmd = vim.diagnostic.open_float, keys = { "n", "gds" }, set = false },
	{ desc = "List diagnostics (project)", cmd = "<cmd>Telescope diagnostics<cr>" },
	{
		desc = "Toggle diagnostics",
		cmd = function()
			vim.diagnostic.enable(not vim.diagnostic.is_enabled())
		end,
	},
	{
		desc = "Toggle diagnostic lines (inline vs below)",
		cmd = function()
			local lines = not vim.diagnostic.config().virtual_lines
			vim.diagnostic.config({ virtual_lines = lines, virtual_text = not lines })
		end,
	},
}, { cat = "diagnostic" })

commander.add({
	{ desc = "Toggle wrap", cmd = toggle("wrap") },
	{ desc = "Toggle spell check", cmd = toggle("spell") },
	{ desc = "Toggle relative numbers", cmd = toggle("relativenumber") },
	{ desc = "Toggle auto-save", cmd = "<cmd>ASToggle<cr>" },
}, { cat = "toggle" })

commander.add({
	{ desc = "Copy relative file path", cmd = copy("%:.") },
	{ desc = "Copy absolute file path", cmd = copy("%:p") },
	{ desc = "Copy file name", cmd = copy("%:t") },
	{ desc = "Recent files", cmd = "<cmd>Telescope oldfiles<cr>" },
	{ desc = "Resume last search", cmd = "<cmd>Telescope resume<cr>" },
	{ desc = "Search keymaps", cmd = "<cmd>Telescope keymaps<cr>" },
}, { cat = "file" })

commander.add({
	{ desc = "Save session", cmd = "<cmd>AutoSession save<cr>" },
	{ desc = "Restore session", cmd = "<cmd>AutoSession restore<cr>" },
	{ desc = "Search sessions", cmd = "<cmd>AutoSession search<cr>" },
	{ desc = "Delete session", cmd = "<cmd>AutoSession delete<cr>" },
}, { cat = "session" })

commander.add({
	{ desc = "Update plugins", cmd = vim.pack.update },
	{ desc = "Update treesitter parsers", cmd = "<cmd>TSUpdate<cr>" },
	{ desc = "Mason (install LSPs/formatters)", cmd = "<cmd>Mason<cr>" },
	{ desc = "Health check (all)", cmd = "<cmd>checkhealth<cr>" },
	{ desc = "Show messages", cmd = "<cmd>messages<cr>" },
	{
		desc = "Edit nvim config",
		cmd = function()
			require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
		end,
	},
}, { cat = "nvim" })
