return {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- optional but nice
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      lang = "golang",

      picker = { provider = "telescope" },

      editor = {
        reset_previous_code = true,
        fold_imports = true,
      },

      console = {
        open_on_runcode = true,
        dir = "row",
        size = {
          width = "90%",
          height = "75%",
        },
        result = {
          size = "60%",
        },
        testcase = {
          virt_text = true,
          size = "40%",
        },
      },

      description = {
        position = "left",
        width = "40%",
        show_stats = true,
      },

      keys = {
        toggle = { "q" },
        confirm = { "<CR>" },
        reset_testcases = "r",
        use_testcase = "U",
        focus_testcases = "H",
        focus_result = "L",
      },
    },
    cmd = { "Leet" },
  }

