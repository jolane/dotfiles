return {
  "Saghen/blink.cmp",
  build = "cargo build --release",
  dependencies = { "rafamadriz/friendly-snippets" },

  version = "*",

  opts = {
    keymap = { preset = "default" },

    appearance = {
      nerd_font_variant = "mono"
    },
    completion = {
      documentation = { auto_show = true },
      list = {
        selection = {
          preselect = true,
          auto_insert = true
        }
      },
      trigger = {
        show_on_insert = true
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" }
    }
  },
}
