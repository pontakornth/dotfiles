-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

-- Set up 'mini.deps' (customize to your liking)
local MiniDeps = require("mini.deps")
MiniDeps.setup({ path = { package = path_package } })
MiniDeps.add({ name = "mini.nvim" })

-- Configuration
vim.opt.signcolumn = "yes"
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.scrolloff = 10
vim.g.mapleader = " " -- Map leader to space

-- Install plugins

local add = MiniDeps.add
add({
	source = "neovim/nvim-lspconfig",
	-- Supply dependencies near target plugin
	depends = { "williamboman/mason.nvim" },
})
add({ source = "VonHeikemen/lsp-zero.nvim", checkout = "v4.x" })
add({
	source = "L3MON4D3/LuaSnip",
	checkout = "v2.*",
})
add({
	source = "hrsh7th/nvim-cmp",
	depends = {
		"hrsh7th/cmp-nvim-lsp",
	},
})

add({
	source = "nvim-treesitter/nvim-treesitter",
	-- Use 'master' while monitoring updates in 'main'
	checkout = "master",
	monitor = "main",
	-- Perform action after every checkout
	hooks = {
		post_checkout = function()
			vim.cmd("TSUpdate")
		end,
	},
})

add("stevearc/oil.nvim")
add("folke/which-key.nvim")
add({
	source = "rose-pine/neovim",
	name = "rose-pine",
})

-- Mason
add("williamboman/mason.nvim")

-- Conform
add("stevearc/conform.nvim")

-- Nvim lint (lint)
add("mfussenegger/nvim-lint")

add({
	source = "nvim-telescope/telescope.nvim",
	depends = {
		"nvim-lua/plenary.nvim",
	},
})

add({
	source = "kelly-lin/telescope-ag",
	depends = {
		"nvim-telescope/telescope.nvim",
	},
})

-- LazyGit because I am lazy.
add({
	source = "kdheepak/lazygit.nvim",
	depends = {
		"nvim-lua/plenary.nvim",
	},
})

-- Tmux navigation
add({
	source = "christoomey/vim-tmux-navigator",
	name = "vim-tmux-navigator",
})

local now, later = MiniDeps.now, MiniDeps.later

local utils = require("utils")

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme rose-pine-moon]])

-- Mini configuration
require("mini.basics").setup()
require("mini.starter").setup()
require("mini.icons").setup()
-- I don't want to use built-in explorer.
require("mini.files").setup()

now(function()
	vim.keymap.set("n", "<C-h>", "<cmd> TmuxNavigateLeft<cr>", { desc = "window left" })
	vim.keymap.set("n", "<C-l>", "<cmd> TmuxNavigateRight<cr>", { desc = "window right" })
	vim.keymap.set("n", "<C-j>", "<cmd> TmuxNavigateDown<cr>", { desc = "window down" })
	vim.keymap.set("n", "<C-k>", "<cmd> TmuxNavigateUp<cr>", { desc = "window up" })
end)

-- Mini configuration that can be configured later
later(function()
	require("mini.extra").setup()
	require("mini.ai").setup()
	require("mini.animate").setup()
	require("mini.surround").setup()
	require("mini.statusline").setup()
	require("mini.tabline").setup()
	require("mini.jump").setup()
	require("mini.pairs").setup()
end)

later(function()
	-- require("codeium").setup()
	-- require("vim-tmux-navigator").setup()
end)

later(function()
	vim.keymap.set("n", "<leader>G", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
	vim.keymap.set("n", "<leader>F", MiniFiles.open, { desc = "Files" })
end)

-- Plugin configuration
now(function()
	require("nvim-treesitter.configs").setup({
		ensure_installed = { "lua", "vimdoc" },
		highlight = { enable = true },
	})
end)

later(function()
	require("oil").setup()
	vim.keymap.set("n", "<leader>O", "<cmd>Oil<cr>")
end)

later(function()
	require("which-key").setup()
end)

now(function()
	require("mason").setup({
		ensure_installed = {
			"gopls",
			"lua-language-server",
			"rust-analyzer",
			"stylua",
		},
	})
end)

now(function()
	local lspconfig_defaults = require("lspconfig").util.default_config
	lspconfig_defaults.capabilities =
		vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

	-- This is where you enable features that only work
	-- if there is a language server active in the file
	vim.api.nvim_create_autocmd("LspAttach", {
		desc = "LSP actions",
		callback = function(event)
			local opts = { buffer = event.buf }

			vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
			vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
			vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
			vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
			vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
			vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
			vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
			vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
			vim.keymap.set("n", "cr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
			vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
			vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
			vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
		end,
	})
end)

-- Telescope
later(function()
	require("telescope").setup()
	local telescope_ag = require("telescope-ag")
	telescope_ag.setup({
		cmd = telescope_ag.cmds.rg, -- defaults to telescope_ag.cmds.ag
	})
	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>ff", function()
		builtin.find_files({ hidden = true })
	end, { desc = "Telescope find files" })
	vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
	vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
	vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
	vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Telescope document symbol" })
	vim.keymap.set("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "Telescope workspace symbol" })
	vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Telescope diagnostics" })
end)

now(function()
	local lspconfig_defaults = require("lspconfig").util.default_config
	lspconfig_defaults.capabilities =
		vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())
end)

-- LSP setup
now(function()
	local lspconfig = require("lspconfig")
	-- LSP without any extra configuration
	local default_lsp = { "lua_ls", "gleam", "basedpyright", "tailwindcss", "gdscript", "gdshader_lsp" }
	for index, value in ipairs(default_lsp) do
		lspconfig[value].setup({})
	end
	-- Prevent Deno from conflicting with TS server (Node and Bun)
	lspconfig.denols.setup({
		root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
	})
	lspconfig.ts_ls.setup({
		root_dir = lspconfig.util.root_pattern("package.json"),
		single_file_support = false,
	})
end)

-- CMP
now(function()
	local cmp = require("cmp")
	local luasnip = require("luasnip")

	cmp.setup({
		sources = {
			{ name = "nvim_lsp" },
			{ name = "buffer" },
			{ name = "luasnip" },
			{ name = "codeium", group_index = 1, priority = 100 },
		},
		snippet = {
			expand = function(args)
				-- You need Neovim v0.10 to use vim.snippet
				require("luasnip").lsp_expand(args.body)
				-- vim.snippet.expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { "i", "s" }),

			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
		}),
	})
end)

later(function()
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			rust = { "rustfmt", lsp_format = "fallback" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
		},
	})
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*",
		callback = function(args)
			require("conform").format({ bufnr = args.buf })
		end,
	})
end)

later(function()
	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		callback = function()
			-- try_lint without arguments runs the linters defined in `linters_by_ft`
			-- for the current filetype
			require("lint").try_lint()

			-- You can call `try_lint` with a linter name or a list of names to always
			-- run specific linters, independent of the `linters_by_ft` configuration
			-- require("lint").try_lint("cspell")
		end,
	})
end)
