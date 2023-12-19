local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers_with_default_config = {
  "html",
  "cssls",
  "tsserver",
  "clangd",
  "ruby_ls",
  "gopls",
  "templ",
  -- Frontend framework
  "astro",
  "svelte",
  "volar", -- note: use takeover mode in large project
  "kotlin_language_server",
  "tailwindcss",
  "gdscript",

  -- "typescript-language-server",
}

for _, lsp in ipairs(servers_with_default_config) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- lspconfig['volar'].setup {
--   filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
-- }

--
-- lspconfig.pyright.setup { blabla}
