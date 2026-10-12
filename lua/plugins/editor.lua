-- plugins related to nvim as an editor
-- must be registered before vim.pack.add so the build runs on first install
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

vim.pack.add({
	"https://github.com/WTFox/luna.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/m4xshen/autoclose.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	"https://github.com/rmagatti/auto-session",
	"https://github.com/j-hui/fidget.nvim",
	"https://github.com/pocco81/auto-save.nvim",
	"https://github.com/akinsho/toggleterm.nvim",
})

-- theme
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		-- Change misspelled words underline/color
		for _, group in ipairs({ "SpellBad", "SpellCap", "SpellLocal", "SpellRare" }) do
			vim.api.nvim_set_hl(0, group, { sp = "#2ecc71", undercurl = true })
		end
	end,
})
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
require("autoclose").setup({})

-- terminal
require("toggleterm").setup({
	open_mapping = [[<c-t>]],
	direction = "horizontal",
})

function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
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
require("nvim-treesitter").install({ "lua", "bash", "go", "python" })

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

-- notifications
require("fidget").setup({})

-- autosave
require("auto-save").setup({})
