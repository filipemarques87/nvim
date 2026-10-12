local opt = vim.opt

opt.number = true -- Line numbers
opt.relativenumber = true -- Relative line numbers
opt.cursorline = true -- Highlight current line
opt.wrap = false -- Don't wrap lines
opt.linebreak = true -- Wrap lines at convenient points (when wrap is on)
opt.scrolloff = 10 -- Keep 10 lines above/below cursor
opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor

-- Indentation
opt.tabstop = 4 -- Tab width
opt.shiftwidth = 4 -- Indent width
opt.softtabstop = 4 -- Soft tab stop
opt.expandtab = true -- Use spaces instead of tabs
opt.smartindent = true -- Smart auto-indenting
opt.shiftround = true -- Round indent

-- Search settings
opt.ignorecase = true -- Case insensitive search
opt.smartcase = true -- Case sensitive if uppercase in search
opt.hlsearch = false -- Don't highlight search results

-- Visual settings
opt.termguicolors = true -- Enable 24-bit colors
opt.signcolumn = "yes" -- Always show sign column
opt.showmatch = true -- Highlight matching brackets
opt.matchtime = 2 -- How long to show matching bracket
opt.synmaxcol = 300 -- Syntax highlighting limit
opt.winminwidth = 5 -- Minimum window width
opt.laststatus = 3 -- Global statusline
opt.winborder = "rounded" -- Border for all floating windows (LSP hover, diagnostics, ...)
opt.fillchars = { diff = "╱", eob = " " }
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- File handling
opt.backup = false -- Don't create backup files
opt.writebackup = false -- Don't create backup before writing
opt.swapfile = false -- Don't create swap files
opt.undofile = true -- Persistent undo
opt.undolevels = 10000
opt.undodir = vim.fn.expand("~/.vim/undodir") -- Undo directory
if vim.fn.isdirectory(vim.o.undodir) == 0 then
	vim.fn.mkdir(vim.o.undodir, "p")
end
opt.autoread = true -- Auto reload files changed outside vim
opt.autowrite = true -- Auto save
opt.confirm = true -- Confirm to save changes before exiting modified buffer

opt.updatetime = 500
opt.timeoutlen = 300
opt.ttimeoutlen = 50 -- Key code timeout (0 breaks terminal escape sequences on WSL)

-- Behavior settings
opt.selection = "exclusive" -- Selection behavior
opt.mouse = "a" -- Enable mouse support
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.jumpoptions = "view"

-- Split behavior
opt.splitbelow = true -- Horizontal splits go below
opt.splitright = true -- Vertical splits go right
opt.splitkeep = "screen"

-- Command-line completion
opt.wildmode = "longest:full,full"
opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

-- Performance improvements
opt.redrawtime = 10000
opt.maxmempattern = 20000

-- Spell
opt.spell = true
opt.spelllang = "en_us"
opt.spelloptions:append("camel")

vim.g.markdown_recommended_style = 0

vim.filetype.add({
	extension = {
		env = "dotenv",
		txt = "markdown",
	},
	filename = {
		[".env"] = "dotenv",
		["env"] = "dotenv",
	},
	pattern = {
		["[jt]sconfig.*.json"] = "jsonc",
		["%.env%.[%w_.-]+"] = "dotenv",
	},
})
