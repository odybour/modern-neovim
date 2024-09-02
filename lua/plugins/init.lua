return {
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",
  "DaikyXendo/nvim-material-icon",
  { "yamatsum/nvim-nonicons", config = true, enabled = false },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "nacro90/numb.nvim", event = "BufReadPre", config = true },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
    main = "ibl",
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = { relative = "editor" },
      select = {
        backend = { "telescope", "fzf", "builtin" },
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      -- background_colour = "#A3CCBE",
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      top_down = false,
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require "notify"
    end,
    enabled = true,
  },
  {
    "monaqa/dial.nvim",
    keys = { { "<C-a>", mode = { "n", "v" } }, { "<C-x>", mode = { "n", "v" } }, { "g<C-a>", mode = { "v" } }, { "g<C-x>", mode = { "v" } } },
    -- stylua: ignore
    config = function()
      vim.api.nvim_set_keymap("n", "<C-a>", require("dial.map").inc_normal(), { desc = "Increment", noremap = true })
      vim.api.nvim_set_keymap("n", "<C-x>", require("dial.map").dec_normal(), { desc = "Decrement", noremap = true })
      vim.api.nvim_set_keymap("v", "<C-a>", require("dial.map").inc_visual(), { desc = "Increment", noremap = true })
      vim.api.nvim_set_keymap("v", "<C-x>", require("dial.map").dec_visual(), { desc = "Decrement", noremap = true })
      vim.api.nvim_set_keymap("v", "g<C-a>", require("dial.map").inc_gvisual(), { desc = "Increment", noremap = true })
      vim.api.nvim_set_keymap("v", "g<C-x>", require("dial.map").dec_gvisual(), { desc = "Decrement", noremap = true })
    end,
  },
  {
    "andymass/vim-matchup",
    event = { "BufReadPost" },
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  { "tpope/vim-surround", event = "BufReadPre", enabled = false },
  {
    "kylechui/nvim-surround",
    event = "BufReadPre",
    opts = {},
  },
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    keys = { { "gc", mode = { "n", "v" } }, { "<C-l>", mode = { "n", "v" } }, { "<C-_>", mode = { "n", "v" } } },
    config = function(_, _)
      local opts = {
        ignore = "^$",
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        ---LHS of toggle mappings in NORMAL mode
        toggler = {
          ---Line-comment toggle keymap
          line = "<C-_>",
          ---Block-comment toggle keymap
          block = "<C-l>",
        },
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
          ---Line-comment keymap
          line = "<C-_>",
          ---Block-comment keymap
          block = "<C-l>",
        },
      }
      require("Comment").setup(opts)
    end,
  },
  -- session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },
  {
    "max397574/better-escape.nvim",
    enabled = true,
    event = "InsertEnter",
    config = function()
      require("better_escape").setup {
        mapping = { "jk" },
      }
    end,
  },
  {
    "TheBlob42/houdini.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {
      escape_sequences = {
        ["t"] = "<ESC>",
        ["c"] = "<ESC>",
      },
    },
  },
  {
    "907th/vim-auto-save",
    event = "VeryLazy",
    enabled = true,
  },
  {
    "simrat39/symbols-outline.nvim",
    event = "VeryLazy",
    enabled = true,
    config = function()
      require("symbols-outline").setup {
        auto_close = false,
      }
    end,
  },
  -- problem when switching between tmux sessions. image does not go away - might revisit in future.
  -- what is more, i am not able to resize, crop, full screen, copy, whatever... it is a MUST to be able to do all these.
  -- {
  -- "3rd/image.nvim",
  -- event = "VeryLazy",
  -- dependencies = {
  --   {
  --     "nvim-treesitter/nvim-treesitter",
  --     build = ":TSUpdate",
  --     config = function()
  --       require("nvim-treesitter.configs").setup {
  --         ensure_installed = { "markdown" },
  --         highlight = { enable = true },
  --       }
  --     end,
  --   },
  -- },
  --   opts = {
  --     backend = "kitty",
  --     -- backend = "ueberzug",
  --     integrations = {
  --       markdown = {
  --         enabled = true,
  --         clear_in_insert_mode = false,
  --         download_remote_images = true,
  --         only_render_image_at_cursor = false,
  --         filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
  --       },
  --       neorg = {
  --         enabled = true,
  --         clear_in_insert_mode = false,
  --         download_remote_images = true,
  --         only_render_image_at_cursor = false,
  --         filetypes = { "norg" },
  --       },
  --     },
  --     max_width = nil,
  --     max_height = nil,
  --     max_width_window_percentage = nil,
  --     max_height_window_percentage = 50,
  --     kitty_method = "normal",
  --     editor_only_render_when_focused = true, -- auto show/hide images when the editor gains/looses focus
  --     tmux_show_only_in_active_window = true ,-- auto show/hide images in the correct Tmux window (needs visual-activity off)
  --   },
  -- },
}
