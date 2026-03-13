return {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
    "svelte",
    "astro",
  },
  root_markers = {
    ".git",
    "package.json",
    "eslint.config.js",
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.json",
  },
  settings = {
    experimental = {
      useFlatConfig = false,
    },
    nodePath = "",
    problems = {},
    rulesCustomizations = {},
    workingDirectory = {
      mode = "location",
    },
  },
  on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
}
