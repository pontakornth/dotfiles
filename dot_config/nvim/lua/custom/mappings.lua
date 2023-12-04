---@type MappingsTable
local M = {}

M.general = {
  n = {
    -- [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>fm"] = {
      function()
        -- vim.lsp.buf.format { async = true }
        require("conform").format { async = true, lsp_fallback = true }
      end,
      "Conform formatting",
    },
    ["<leader>fl"] = {
      function()
        require("lint").try_lint()
      end,
      "Nvim Lint",
    },
    ["<leader>G"] = {
      function()
        vim.cmd ":LazyGit"
      end,
      "LazyGit",
    },
    ["<leader>xx"] = {
      function()
        require("trouble").toggle()
      end,
    },
    ["<leader>xw"] = {
      function()
        require("trouble").toggle "workspace_diagnostics"
      end,
    },
    ["<leader>xd"] = {
      function()
        require("trouble").toggle "document_diagnostics"
      end,
    },
    ["<leader>xq"] = {
      function()
        require("trouble").toggle "quickfix"
      end,
    },
    ["<leader>xl"] = {
      function()
        require("trouble").toggle "loclist"
      end,
    },
  },
  v = {
    [">"] = { ">gv", "indent" },
  },
}

-- more keybinds!

return M
