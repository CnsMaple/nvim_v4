-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

local Path = require "plenary.path"

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.colorscheme.tokyonight-nvim" },
  { import = "astrocommunity.motion.mini-surround" },

  { import = "astrocommunity.utility.noice-nvim" },
  { import = "extras.noice-nvim" },

  { import = "astrocommunity.diagnostics.trouble-nvim" },
  { import = "extras.trouble-nvim" },

  { import = "astrocommunity.utility.nvim-toggler" },
  { import = "extras.nvim-toggler" },

  { import = "astrocommunity.terminal-integration.toggleterm-manager-nvim" },

  { import = "astrocommunity.lsp.lsp-signature-nvim" },
  { import = "extras.lsp-signature-nvim" },

  { import = "astrocommunity.motion.mini-move" },
  { import = "astrocommunity.search.nvim-spectre" },
  { import = "astrocommunity.editing-support.multicursors-nvim" },
  { import = "astrocommunity.debugging.nvim-dap-virtual-text" },
  { import = "astrocommunity.motion.marks-nvim" },
  { import = "astrocommunity.motion.vim-matchup" },

  { import = "astrocommunity.scrolling.neoscroll-nvim" },
  { import = "extras.neoscroll-nvim" },

  { import = "astrocommunity.completion.cmp-cmdline" },
  { import = "astrocommunity.completion.codeium-nvim" },

  { import = "astrocommunity.completion.copilot-cmp" },
  { import = "extras.copilot-chat" },

  { import = "astrocommunity.motion.flash-nvim" },

  -- 这个是cpp的配置
  -- { import = "astrocommunity.pack.cpp" },
  -- { import = "extras.cpp" },

  -- cmake的配置
  -- { import = "astrocommunity.pack.cmake" },

  -- 这个是vue的配置
  -- { import = "astrocommunity.pack.html-css" },
  -- { import = "astrocommunity.pack.vue" },

  -- 这个是json的配置
  { import = "astrocommunity.pack.json" },

  -- lua的配置
  { import = "extras.lua" },

  -- markdown的配置
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },

  -- python的配置
  { import = "astrocommunity.pack.python" },
  { import = "extras.pyright" },
  { import = "extras.python" },

  { import = "extras.fitten-code" },
  -- { import = "astrocommunity.completion.fittencode-nvim" },

  { import = "astrocommunity.pack.dart" },
}
