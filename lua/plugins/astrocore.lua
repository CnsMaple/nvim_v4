-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = true, -- sets vim.opt.wrap
        showcmdloc = "statusline", -- 按键显示
        -- clipboard = "unnamedplus",
        -- vim.opt.clipboard:append "unnamedplus"
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
        inlay_hints_enabled = true,
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        ["<S-h>"] = { "^", desc = "Move to first non-blank character of line" },
        ["<S-l>"] = { "$", desc = "Move to end of line" },

        ["U"] = { "<cmd>redo<CR>", desc = "redo" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<Leader>b"] = { desc = "Buffers" },
        -- quick save
        -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command

        ["<leader>ur"] = {
          "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
          desc = "Redraw / clear hlsearch / diff update",
        },
      },
      i = {
        ["jj"] = { "<cmd>nohl<cr><esc>", desc = "exit insert mode" },
        ["<C-b>"] = { "<ESC>^i", desc = "move beginning of line" },
        ["<C-e>"] = { "<End>", desc = "move end of line" },
        ["<C-h>"] = { "<Left>", desc = "move left" },
        ["<C-l>"] = { "<Right>", desc = "move right" },
        ["<C-j>"] = { "<Down>", desc = "move down" },
        ["<C-k>"] = { "<Up>", desc = "move up" },
      },
      v = {
        ["<S-h>"] = { "^", desc = "Move to first non-blank character of line" },
        ["<S-l>"] = { "$g_", desc = "Move to end of line" },
      },
      t = {
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
        ["JJ"] = { "<C-\\><C-n>", desc = "Exit Terminal Mode" },
      },
    },
  },
}
