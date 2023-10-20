local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')

require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

require("mason-lspconfig").setup {
  ensure_installed = {
    "tsserver",
    "html",
    "cssls",
    "tailwindcss",
    "graphql",
    "lua_ls",
  },
  automatic_installation = true,
}
