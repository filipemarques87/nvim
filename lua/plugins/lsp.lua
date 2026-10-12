vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/stevearc/conform.nvim",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf, silent = true }
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		-- Neovim already provides these by default:
		--   K hover · grn rename · gra code action · grr references · gri implementation
		--   grt type definition · gO document symbols · <C-s> (insert) signature help
		--   ]d / [d next/prev diagnostic · <C-w>d diagnostic float
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gdd", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gdn", function()
			vim.diagnostic.jump({ count = 1 })
		end, opts)
		vim.keymap.set("n", "gdp", function()
			vim.diagnostic.jump({ count = -1 })
		end, opts)
		vim.keymap.set("n", "gds", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "<leader>da", vim.diagnostic.setloclist, opts)

		-- Server capabilities spec:
		-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#serverCapabilities
		if client.server_capabilities.documentHighlightProvider then
			vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
			vim.api.nvim_clear_autocmds({ buffer = ev.buf, group = "lsp_document_highlight" })
			vim.api.nvim_create_autocmd("CursorHold", {
				callback = vim.lsp.buf.document_highlight,
				buffer = ev.buf,
				group = "lsp_document_highlight",
				desc = "Document Highlight",
			})
			vim.api.nvim_create_autocmd("CursorMoved", {
				callback = vim.lsp.buf.clear_references,
				buffer = ev.buf,
				group = "lsp_document_highlight",
				desc = "Clear All the References",
			})
		end
	end,
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					vim.env.VIMRUNTIME,
					-- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
					vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
				},
			},
			telemetry = { enable = false },
		},
	},
})

vim.lsp.config("basedpyright", {
	settings = {
		basedpyright = {
			analysis = {
				-- "recommended" (basedpyright's default) is very strict; "standard" matches pyright
				typeCheckingMode = "standard",
			},
		},
	},
})

vim.lsp.enable({ "lua_ls", "gopls", "basedpyright" })

vim.diagnostic.config({
	underline = true,
	virtual_text = true,
	severity_sort = true,
	signs = true,
})

-- autocomplete: lazy load on first insert mode entry (may not necessary)
local group = vim.api.nvim_create_augroup("BlinkCmpLazyLoad", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
	pattern = "*",
	group = group,
	once = true,
	callback = function()
		require("blink.cmp").setup({
			appearance = {
				nerd_font_variant = "mono",
				use_nvim_cmp_as_default = true,
			},
			completion = {
				documentation = { auto_show = true },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		})
	end,
})

require("mason").setup()

-- code format
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		go = { "goimports", "gofumpt" },
		sql = { "sqruff" },
		python = { "ruff_organize_imports", "ruff_format" },
	},
})

vim.keymap.set({ "n", "v" }, "grf", function()
	require("conform").format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 3000,
	})
end, { desc = "Format file or range (conform)" })
