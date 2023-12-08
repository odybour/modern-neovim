return {
  {
    "dpayne/CodeGPT.nvim",
    build = "pip install tiktoken",
    cmd = { "Chat" },
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require "codegpt.config"
    end,
  },
}
