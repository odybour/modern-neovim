return {
  "nvim-tree/nvim-tree.lua",
  enabled = true,
  cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
  keys = {
    { "<M-1>", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
    { "<C-n>", "<cmd>NvimTreeFindFile<cr>", desc = "Find-File" },
  },
  opts = {
    disable_netrw = false,
    hijack_netrw = true,
    respect_buf_cwd = true,
    view = {
      number = true,
      relativenumber = true,
    },
    filters = {
      -- show .dotfiles and .gitignore files
      git_ignored = false,
      dotfiles = false,
      git_clean = false,
      no_buffer = false,
    },
    sync_root_with_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true,
    },
    actions = {
      open_file = {
        quit_on_open = false,
        resize_window = false,
      },
    },
    -- groups empty folders (e.g. java packages)
    renderer = {
      group_empty = true,
      full_name = true,
    },
  },
}
