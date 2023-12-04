local conform = require "conform"

-- Format command
vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format { async = true, lsp_fallback = true, range = range }
end, { range = true })

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

local prettier_config = { "prettier" }
local format_on_save_option = {
  lsp_fallback = true,
  timeout_ms = 1000,
}
conform.setup {
  formatters_by_ft = {
    -- Neovim configuration
    lua = { "stylua" },
    -- Web development
    javascript = prettier_config,
    typescript = prettier_config,
    javascriptreact = prettier_config,
    typescriptreact = prettier_config,
    svelte = prettier_config,
    css = prettier_config,
    html = prettier_config,
    yaml = prettier_config,
    markdown = prettier_config,
    json = prettier_config,
    graphql = prettier_config,
    python = function(bufnr)
      if require("conform").get_formatter_info("ruff_format", bufnr).available then
        return { "ruff_format" }
      else
        return { "isort", "black" }
      end
    end,
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return format_on_save_option
  end,
}
