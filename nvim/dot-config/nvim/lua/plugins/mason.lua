return {
  "mason-org/mason.nvim",
  lazy = false,
  cmd = "Mason",
  build = ":MasonUpdate",
  keys = {
    { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
  },
  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
    ensure_installed = {
      "gopls",
      "lua-language-server",
      "marksman",
      "typescript-language-server",
      "eslint-lsp",
      "stylua",
      "shfmt",
      "shellcheck",
      "gofumpt",
      "goimports",
      "prettierd",
    },
  },
  config = function(_, opts)
    local settings = vim.tbl_deep_extend("force", {}, opts)
    local ensure_installed = settings.ensure_installed or {}
    settings.ensure_installed = nil

    require("mason").setup(settings)

    local registry = require("mason-registry")
    registry.refresh(function()
      for _, tool in ipairs(ensure_installed) do
        local ok, pkg = pcall(registry.get_package, tool)
        if ok and not pkg:is_installed() then
          pkg:install()
        end
      end
    end)
  end,
}
