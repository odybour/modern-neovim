return {
  {
    "mrjones2014/legendary.nvim",
    keys = {
      { "<C-S-p>", "<cmd>Legendary<cr>", desc = "Legendary" },
      { "<leader>hc", "<cmd>Legendary<cr>", desc = "Command Palette" },
    },
    opts = {
      which_key = { auto_register = true },
    },
  },
  {
    "folke/which-key.nvim",
    cond = function()
      return require("config").keymenu.which_key
    end,
    dependencies = {
      "mrjones2014/legendary.nvim",
    },
    event = "VeryLazy",
    opts = {
      setup = {
        show_help = true,
        plugins = { spelling = true },
        key_labels = { ["<leader>"] = "SPC" },
        triggers = "auto",
        window = {
          border = "single", -- none, single, double, shadow
          position = "bottom", -- bottom, top
          margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
          padding = { 1, 1, 1, 1 }, -- extra window padding [top, right, bottom, left]
          winblend = 0,
        },
        layout = {
          height = { min = 4, max = 25 }, -- min and max height of the columns
          width = { min = 20, max = 50 }, -- min and max width of the columns
          spacing = 3, -- spacing between columns
          align = "left", -- align columns left, center or right
        },
      },
      defaults = {
        prefix = "<leader>",
        mode = { "n", "v" },
        w = { "<cmd>update!<CR>", "Save" },
        -- stylua: ignore
        q = { name = "Quit/Session",
          q = { function() require("utils").quit() end, "Quit", },
          t = { "<cmd>tabclose<cr>", "Close Tab" },
        },
        a = { name = "+AI" },
        b = { name = "+Buffer" },
        d = { name = "+Debug" },
        D = { name = "+Database" },
        -- stylua: ignore
        f = {
          name = "+File" ,
          t = { function() require("utils").open_term("yazi") end, "Terminal File Manager", },
        },
        h = { name = "+Help" },
        j = { name = "+Jump" },
        g = { name = "+Git", h = { name = "+Hunk" }, t = { name = "+Toggle" }, w = { name = "+Work Tree" } },
        n = { name = "+Notes" },
        p = { name = "+Project" },
        -- o = { name = "+Orgmode" },
        r = { name = "+Refactor" },
        t = { name = "+Test", N = { name = "+Neotest" }, o = { "+Overseer" } },
        v = { name = "+View" },
        z = { name = "+System" },
        -- stylua: ignore
        s = {
          name = "+Search",
          c = { function() require("utils.coding").cht() end, "Cheatsheets", },
          o = { function() require("utils.coding").stack_overflow() end, "Stack Overflow", },
        },
        l = {
          name = "+Language",
          g = { name = "Annotation" },
          x = {
            name = "Swap Next",
            f = "Function",
            p = "Parameter",
            c = "Class",
          },
          X = {
            name = "Swap Previous",
            f = "Function",
            p = "Parameter",
            c = "Class",
          },
        },
        c = {
          name = "ChatGPT",
          c = { "<cmd>ChatGPT<CR>", "ChatGPT" },
          e = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction", mode = { "n", "v" } },
          g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction", mode = { "n", "v" } },
          t = { "<cmd>ChatGPTRun translate<CR>", "Translate", mode = { "n", "v" } },
          k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
          d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring", mode = { "n", "v" } },
          a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
          o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
          s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
          f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs", mode = { "n", "v" } },
          x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
          r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit", mode = { "n", "v" } },
          l = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis", mode = { "n", "v" } },
        },
      },
    },
    config = function(_, opts)
      local wk = require "which-key"
      wk.setup(opts.setup)
      wk.register(opts.defaults)
    end,
  },
}
