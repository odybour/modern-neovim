if vim.g.vscode then
  -- VS Code only mappings
  vim.keymap.set("n", "gi", function()
    vim.fn.VSCodeNotify "editor.action.goToImplementation"
  end)
  vim.keymap.set("n", "gr", function()
    vim.fn.VSCodeNotify "editor.action.goToReferences"
  end)
  -- https://github.com/vscode-neovim/vscode-neovim/issues/298
  vim.opt.clipboard:append "unnamedplus"
else
  require "config.options"
  require "config.lazy"

  if vim.fn.argc(-1) == 0 then
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("ModernNeovim", { clear = true }),
      pattern = "VeryLazy",
      callback = function()
        require "config.autocmds"
        require "config.keymaps"
        require "utils.contextmenu"
      end,
    })
  else
    require "config.autocmds"
    require "config.keymaps"
    require "utils.contextmenu"
  end
end
