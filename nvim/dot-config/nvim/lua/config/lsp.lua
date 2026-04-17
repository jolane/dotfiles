local severity = vim.diagnostic.severity

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, blink = pcall(require, "blink.cmp")
if ok then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.lsp.enable({
  "gopls",
  "lua_ls",
  "marksman",
  "ts_ls",
  "eslint",
})

vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
      [severity.ERROR] = "󰅚 ",
      [severity.WARN] = "󰀪 ",
      [severity.INFO] = "󰋽 ",
      [severity.HINT] = "󰌶 ",
    },
  },
})

vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]e", function()
  vim.diagnostic.goto_next({ severity = severity.ERROR })
end, { desc = "Next error" })
vim.keymap.set("n", "[e", function()
  vim.diagnostic.goto_prev({ severity = severity.ERROR })
end, { desc = "Prev error" })
vim.keymap.set("n", "]w", function()
  vim.diagnostic.goto_next({ severity = severity.WARN })
end, { desc = "Next warning" })
vim.keymap.set("n", "[w", function()
  vim.diagnostic.goto_prev({ severity = severity.WARN })
end, { desc = "Prev warning" })

local group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(event)
    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local builtin = require("telescope.builtin")

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map("n", "gd", vim.lsp.buf.definition, "Goto definition")
    map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
    map("n", "gr", builtin.lsp_references, "References")
    map("n", "gI", vim.lsp.buf.implementation, "Goto implementation")
    map("n", "gy", vim.lsp.buf.type_definition, "Goto type definition")
    map("n", "K", vim.lsp.buf.hover, "Hover")
    map("n", "gK", vim.lsp.buf.signature_help, "Signature help")
    map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
    map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
    map("n", "<leader>co", function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { "source.organizeImports" },
          diagnostics = {},
        },
      })
    end, "Organize imports")
    map("n", "<leader>cl", function()
      vim.cmd("checkhealth vim.lsp")
    end, "Lsp info")
    map("n", "<leader>ss", builtin.lsp_document_symbols, "Document symbols")
    map("n", "<leader>sS", builtin.lsp_dynamic_workspace_symbols, "Workspace symbols")

    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    if client and client:supports_method("textDocument/foldingRange") then
      vim.opt_local.foldmethod = "expr"
      vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
  end,
})
