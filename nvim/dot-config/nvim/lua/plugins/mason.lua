return {
  "mason-org/mason.nvim",
  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    },
    ensure_installed = {
      "lua_ls",
      "gopls",
      "ts_ls",
      "marksman",
      "eslint",
    },
    automatic_installation = true,
  }
}
