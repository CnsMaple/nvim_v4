return {
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = function(_, opts)
      -- Inject codeium into cmp sources, with high priority
      table.insert(opts.sources, 1, {
        name = "fittencode",
        group_index = 1,
        priority = 10000,
      })

      -- lspkind.lua
      local lspkind = require "lspkind"
      lspkind.init {
        symbol_map = {
          FittenCode = "",
        },
      }

      vim.api.nvim_set_hl(0, "CmpItemKindFittenCode", { fg = "#E13E30" })
    end,
  },
  -- {
  --   "saghen/blink.cmp",
  --   -- add fittencode.nvim to dependencies
  --   dependencies = {
  --     { "luozhiya/fittencode.nvim" },
  --   },
  --   opts = {
  --     -- add fittencode to sources
  --     sources = {
  --       completion = {
  --         enabled_providers = { "lsp", "path", "snippets", "buffer", "fittencode" },
  --       },
  --
  --       -- set custom providers with fittencode
  --       providers = {
  --         fittencode = {
  --           name = "fittencode",
  --           module = "fittencode.sources.blink",
  --         },
  --       },
  --     },
  --   },
  -- },
}
