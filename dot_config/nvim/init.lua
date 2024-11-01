-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })

-- Install plugins

local add = MiniDeps.add
add({
  source = 'neovim/nvim-lspconfig',
  -- Supply dependencies near target plugin
  depends = { 'williamboman/mason.nvim' },
})

add({
  source = 'nvim-treesitter/nvim-treesitter',
  -- Use 'master' while monitoring updates in 'main'
  checkout = 'master',
  monitor = 'main',
  -- Perform action after every checkout
  hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})

add('stevearc/oil.nvim')
add('folke/which-key.nvim')
add('catppuccin/nvim')
add('ellisonleao/gruvbox.nvim' )

-- Mason
add('williamboman/mason.nvim')


local now, later = MiniDeps.now, MiniDeps.later

vim.o.background = "dark" -- or "light" for light mode
vim.cmd[[colorscheme gruvbox]]

-- Mini configuration
require('mini.basics').setup()
require('mini.starter').setup()
require('mini.icons').setup()

-- Mini configuration that can be configured later
later(function ()
	require('mini.surround').setup()
	require('mini.statusline').setup()
	require('mini.tabline').setup()
	require('mini.jump').setup()
end)

-- Plugin configuration
now(function ()
	require('nvim-treesitter.configs').setup({
	  ensure_installed = { 'lua', 'vimdoc' },
	  highlight = { enable = true },
	})
end
)

later(function ()
	require('oil').setup()
end)

later(function ()
	require('which-key').setup()
end)

now(function ()
	require('mason').setup({
	  ensure_installed = {
		  "gopls",
		  "lua-language-server",
		  "rust-analyzer",
		  "stylua",
	  }
	})
end)


