if not require("config").pde.json then
  return {}
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "json", "json5", "jsonc" })
      end
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/SchemaStore.nvim",
    },
    opts = {
      servers = {
        jsonls = {
          settings = function()
            return {
              json = {
                format = {
                  enable = true,
                },
                validate = { enable = true },
                schemas = require("schemastore").json.schemas(),
              },
            }
          end,
        },
      },
    },
  },
}
