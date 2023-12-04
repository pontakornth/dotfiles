local M = {}

-- stylua: ignore
local autotag_filetypes = {
    'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'rescript',
    'xml',
    'php',
    'markdown',
    'astro', 'glimmer', 'handlebars', 'hbs',
    'htmldjango',
    'eruby',
    'templ'
}

M.treesitter = {
  ensure_installed = {
    -- Vim configuration
    "vim",
    "lua",
    -- Web development
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "astro",
    "python",
    -- lowlevel stuff
    "c",
    -- Document thingy
    "markdown",
    "markdown_inline",
    -- Other
    "ruby",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
  autotag = {
    enable = true,
    filetypes = autotag_filetypes,
  },
  highlight = {
    enabled = true,
    additional_vim_regex_highlighting = false,
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",

    -- c/cpp stuff
    "clangd",
    "clang-format",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
