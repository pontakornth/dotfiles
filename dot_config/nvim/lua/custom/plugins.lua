local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {

	-- Override plugin definition options

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- format & linting
			-- {
			--   "jose-elias-alvarez/null-ls.nvim",
			--   config = function()
			--     require "custom.configs.null-ls"
			--   end,
			-- },
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end, -- Override to setup mason-lspconfig
	},
	-- Formatting and linting
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "ConformInfo" },
		config = function()
			require("custom.configs.conform")
		end,
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("custom.configs.nvim-lint")
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
	},

	-- override plugin configs
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
		dependencies = {
			"windwp/nvim-ts-autotag",
			"vrischmann/tree-sitter-templ",
		},
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},

	-- Install a plugin
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},
	{
		"tpope/vim-surround",
		lazy = false, -- This is a Vim plugin.
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"stevearc/oil.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "Oil" },
		event = "VeryLazy",
	},
	{
		"RaafatTurki/corn.nvim",
		cmd = {
			"CornToggle",
			"CornScope",
			"CornScopeCycle",
			"CornRender",
		},
		opts = {},
		event = "VeryLazy",
	},

	-- To make a plugin not be loaded
	-- {
	--   "NvChad/nvim-colorizer.lua",
	--   enabled = false
	-- },

	-- All NvChad plugins are lazy-loaded by default
	-- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
	-- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
	-- {
	--   "mg979/vim-visual-multi",
	--   lazy = false,
	-- }
}

return plugins
