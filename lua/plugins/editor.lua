-- plugins related to nvim as an editor
vim.pack.add({
	-- "https://github.com/sainnhe/gruvbox-material",
	"https://github.com/WTFox/luna.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/m4xshen/autoclose.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	"https://github.com/rmagatti/auto-session",
	"https://github.com/numToStr/Comment.nvim",
	"https://github.com/j-hui/fidget.nvim",
	"https://github.com/pocco81/auto-save.nvim",
	"https://github.com/akinsho/toggleterm.nvim",
	"https://github.com/ojroques/nvim-bufdel",
	"https://github.com/stevearc/stickybuf.nvim",

    "https://github.com/FeiyouG/commander.nvim"
})

require("commander").setup({})
require("commander").add({
    {
        desc = "Open commander",
        cmd = require("commander").show,
        keys = { "n", "<ledader>fc" },
    }
})


-- theme
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		local set = vim.api.nvim_set_hl

		-- set(0, "DiagnosticVirtualTextError", { fg = "#fb4934", bg = "NONE" })
		-- set(0, "DiagnosticVirtualTextWarn",  { fg = "#fabd2f", bg = "NONE" })
		-- set(0, "DiagnosticVirtualTextInfo",  { fg = "#83a598", bg = "NONE" })
		-- set(0, "DiagnosticVirtualTextHint",  { fg = "#8ec07c", bg = "NONE" })
		-- set(0, "CursorLine", { bg = "#3c3836" })
		-- set(0, "CursorLineNr", { fg = "#fafd2f", bg = "#3c3836", bold = true })
		-- Change misspelled words (SpellBad) underline/color
		vim.api.nvim_set_hl(0, "SpellBad", { sp = "#2ecc71", undercurl = true })
		vim.api.nvim_set_hl(0, "SpellCap", { sp = "#2ecc71", undercurl = true })
		vim.api.nvim_set_hl(0, "SpellLocal", { sp = "#2ecc71", undercurl = true })
		vim.api.nvim_set_hl(0, "SpellRare", { sp = "#2ecc71", undercurl = true })
	end,
})
-- vim.g.gruvbox_material_enable_italic = true
-- vim.cmd.colorscheme("gruvbox-material")
vim.cmd.colorscheme("luna")

-- status line
require("lualine").setup({
	sections = {
		lualine_c = { {
			"filename",
			path = 1,
		} },
	},
})

-- parentheses autoclose
require("autoclose").setup({
	keys = {
		-- ["<"] = { escape = false, close = true, pair = "<>" },
	},
})

-- terminal
require("toggleterm").setup({
	open_mapping = [[<c-t>]],
	direction = "horizontal",
})

function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
	-- vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
	vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- telescope
require("telescope").setup({})
require("telescope").load_extension("fzf")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "Telescope grep string" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
			if not ev.data.active then
				vim.cmd.packadd("telescope-fzf-native.nvim")
			end
			vim.system({ "make" }, { cwd = ev.data.path }):wait()
		end
	end,
})

-- netrw file explore
vim.g.netrw_winsize = 30 -- windown size to 30%
vim.g.netrw_banner = 0

vim.keymap.set(
	"n",
	"<leader>ee",
	"<cmd>:Lexplore %:p:h<cr>",
	{ desc = "Open netrw in the directory of the current file" }
)
vim.keymap.set("n", "<leader>er", "<cmd>:Lexplore<cr>", { desc = "Open/close netrw in the current working directory" })

-- treesitter
require("nvim-treesitter").setup({})
require("nvim-treesitter").install({ "lua", "bash", "go" })

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

-- session
require("auto-session").setup({})

-- comments
require("Comment").setup({})
vim.keymap.set("n", "<leader>ct", function()
	require("Comment.api").toggle.linewise.current()
end)
vim.keymap.set("n", "<leader>co", function()
	require("Comment.api").insert.linewise.below()
end)
vim.keymap.set("n", "<leader>cO", function()
	require("Comment.api").insert.linewise.above()
end)
vim.keymap.set("n", "<leader>cA", function()
	require("Comment.api").insert.linewise.eol()
end)
vim.keymap.set("v", "gcc", "<Plug>(comment_toggle_linewise_visual)gv")

-- notifications
require("fidget").setup({})

-- autosave
require("auto-save").setup({})

-- Buffer delete
require("bufdel").setup({
	next = "tabs",
	quit = false, -- quit Neovim when last buffer is closed
})

require("stickybuf").setup({})
