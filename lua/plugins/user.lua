-- 这个是neovide的设置

if vim.fn.has "win32" == 1 then
  -- 在Windows上运行的代码
  vim.o.guifont = "Maple Mono SC NF:h12.5"
elseif vim.fn.has "unix" == 1 then
  -- 在Unix-like系统（包括Linux和macOS）上运行的代码
  if vim.fn.has "macunix" == 1 then
    -- 在macOS上运行的代码
  else
    -- 在Linux上运行的代码
    vim.o.guifont = "Maple Mono SC NF:h12.5"
  end
else
  -- 在其他操作系统上运行的代码
  print "This is an unsupported operating system."
end

-- 将 g:neovide_no_idle 设置为布尔值将强制 Neovide 始终重绘。如果动画似乎停止得太早，这可能是一个快速解决方案。
vim.g.neovide_no_idle = true
-- 退出确认
vim.g.neovide_confirm_quit = true
-- 全屏(没有任务栏的那种)
vim.g.neovide_fullscreen = false
-- 记住窗口大小
vim.g.neovide_remember_window_size = true
-- 没有焦点的时候的刷新率
vim.g.neovide_refresh_rate_idle = 5
-- 普通刷新率
vim.g.neovide_refresh_rate = 60
-- 滚动动画的时间
vim.g.neovide_scroll_animation_length = 0.3

vim.opt.clipboard:append("unnamedplus")

vim.keymap.set(
  { "n", "i" },
  "<M-s>",
  function() require("lsp_signature").toggle_float_win() end,
  { silent = true, noremap = true, desc = "toggle signature" }
)

local Path = require "plenary.path"
local nvim_data_codeium_path = tostring(Path:new(vim.fn.stdpath "data", "codeium"))

return {
  -- 预览跳转
  {
    "nacro90/numb.nvim",
    event = "VeryLazy",
    enabled = true,
    opts = {
      show_numbers = true, -- Enable 'number' for the window while peeking
      show_cursorline = true, -- Enable 'cursorline' for the window while peeking
      hide_relativenumbers = true, -- Enable turning off 'relativenumber' for the window while peeking
      number_only = false, -- Peek only when the command is only a number instead of when it starts with a number
      centered_peeking = true, -- Peeked line will be centered relative to window
    },
  },
  -- 字符反转
  {
    "nguyenvukhang/nvim-toggler",
    event = "BufEnter",
    config = function()
      require("nvim-toggler").setup {
        -- init.lua
        -- your own inverses
        inverses = {
          ["True"] = "False",
        },
        -- removes the default <leader>i keymap
        remove_default_keybinds = true,
        vim.keymap.set({ "n", "v" }, "<leader>i", require("nvim-toggler").toggle, { desc = "Reverse Text" }),
      }
    end,
  },
  -- 文本移动
  {
    "echasnovski/mini.move",
    version = "*",
    config = true,
    event = "BufEnter",
  },
  -- 文本统一替换
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    enabled = true,
    event = "VeryLazy",
    opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {
        { "<leader>fR", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },
  -- 比";"更好用的插件
  { "tpope/vim-repeat", event = "VeryLazy" },
  -- 多文本选择
  {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
      "smoka7/hydra.nvim",
    },
    opts = {},
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
    keys = {
      {
        mode = { "v", "n" },
        "<Leader>m",
        "<cmd>MCstart<cr>",
        desc = "Create a selection for selected text or word under the cursor",
      },
    },
  },
  -- 更好的主题
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = false,
    },
  },
  -- markdown 预览
  {
    "toppair/peek.nvim",
    enabled = vim.fn.has "win32" == 1,
    build = "deno task --quiet build:fast",
    ft = { "markdown" },
    opts = function(_, opts)
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
      return opts
    end,
    cmd = {
      "PeekOpen",
      "PeekClose",
    },
  },
  -- markdown 图片粘贴
  {
    "CnsMaple/clipboard-image.nvim",
    ft = { "markdown" },
    opts = {
      markdown = {
        img_dir = { "%:p:h", "img" },
        img_dir_txt = "img",
        img_name = function() return vim.fn.input { prompt = "Enter file name: " } end,
      },
    },
    cmd = { "PasteImg" },
  },
  -- markdown 更多语法支持
  {
    "jakewvincent/mkdnflow.nvim",
    enabled = true,
    ft = { "markdown" },
    config = function() require("mkdnflow").setup {} end,
  },
  -- 调试的虚拟文本
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
    event = "User AstroFile",
    opts = {},
  },
  -- 更好的标记插件
  {
    "chentoast/marks.nvim",
    event = "User AstroFile",
    opts = {
      excluded_filetypes = {
        "qf",
        "NvimTree",
        "toggleterm",
        "TelescopePrompt",
        "alpha",
        "netrw",
        "neo-tree",
      },
    },
  },
  -- 窗口移动插件
  {
    "sindrets/winshift.nvim",
    event = "User AstroFile",
  },
  -- 搜索高亮
  {
    "kevinhwang91/nvim-hlslens",
    opts = {},
    event = "BufRead",
    init = function() vim.on_key(nil, vim.api.nvim_get_namespaces()["auto_hlsearch"]) end,
    config = function()
      require("hlslens").setup()

      local kopts = { noremap = true, silent = true }

      vim.keymap.set("n", "n", function()
        if vim.fn.searchcount().total ~= 0 then
          vim.cmd "execute('normal! ' . v:count1 . 'n')"
          vim.cmd "lua require('hlslens').start()"
        end
      end, kopts)
      vim.keymap.set("n", "N", function()
        if vim.fn.searchcount().total ~= 0 then
          vim.cmd "execute('normal! ' . v:count1 . 'N')"
          vim.cmd "lua require('hlslens').start()"
        end
      end, kopts)
      -- vim.api.nvim_set_keymap('n', 'N',
      --     [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
      --     kopts)
      -- vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      -- vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      -- vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      -- vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    end,
  },
  -- 字符匹配 if else
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "andymass/vim-matchup" },
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup", fullwidth = 1, highlight = "Normal", syntax_hl = 1 }
    end,
    opts = { matchup = { enable = true } },
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      -- options
    },
  },

  -- 丝滑滚动
  {
    "declancm/cinnamon.nvim",
    enabled = vim.g.neovide == nil,
    event = "VeryLazy",
    opts = {
      -- default_delay = 1,
      -- extra_keymaps = false, -- Create extra keymaps.
      -- extended_keymaps = false, -- Create extended keymaps.
      -- scroll_limit = 50,
    },
  },
  -- cmd的辅助
  {
    "hrsh7th/cmp-cmdline",
    keys = { ":", "/", "?" }, -- lazy load cmp on more keys along with insert mode
    dependencies = { "hrsh7th/nvim-cmp" },
    opts = function()
      local cmp = require "cmp"
      return {
        {
          type = "/",
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = "buffer" },
          },
        },
        {
          type = ":",
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = "path" },
          }, {
            {
              name = "cmdline",
              option = {
                ignore_cmds = { "Man", "!" },
              },
            },
          }),
        },
      }
    end,
    config = function(_, opts)
      local cmp = require "cmp"
      vim.tbl_map(function(val) cmp.setup.cmdline(val.type, val) end, opts)
    end,
  },
  -- 快速移动插件
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        search = {
          enabled = false,
        },
        char = {
          enabled = false,
        },
      },
    },
    keys = {
      {
        "f",
        mode = { "n", "x", "o" },
        function() require("flash").jump() end,
        desc = "Flash",
      },
      {
        "F",
        mode = { "n", "o", "x" },
        function() require("flash").treesitter() end,
        desc = "Flash Treesitter",
      },
    },
  },
  -- 参数提示
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "ray-x/lsp_signature.nvim",
      opts = {
        hint_enable = false, -- disable hints as it will crash in some terminal
      },
    },
  },
  -- codeium
  {
    {
      "hrsh7th/nvim-cmp",
      -- dependencies = { "Exafunction/codeium.nvim" },
      opts = function(_, opts)
        local cmp = require "cmp"

        table.insert(opts.sources, { name = "codeium", priority = 1251, keyword_length = 1, group_index = 1 })

        local lspkind = require "lspkind"
        lspkind.symbol_map["Codeium"] = ""
        vim.api.nvim_set_hl(0, "CmpItemKindCodeium", { fg = "#32d2bf" })

        return opts
      end,
    },
    {
      "CnsMaple/codeium.nvim",
      cmd = "Codeium",
      event = "User AstroFile",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
      },
      -- opts = function(_, opts)
      --   local Path = require "plenary.path"
      --   -- local nvim_data_codeium_path = vim.fn.stdpath "data" .. "\\codeium"
      --   local nvim_data_codeium_path = tostring(Path:new(vim.fn.stdpath "data", "codeium"))
      --
      --   -- opts.config_path = nvim_data_codeium_path .. "\\config.json"
      --   opts.config_path = tostring(Path:new(nvim_data_codeium_path, "config.json"))
      --   -- opts.bin_path = nvim_data_codeium_path .. "\\bin"
      --   opts.bin_path = tostring(Path:new(nvim_data_codeium_path, "bin"))
      --
      --   opts["tools"]["language_server"] =
      --     tostring(Path:new(nvim_data_codeium_path, "bin", "1.8.4", "language_server_windows_x64.exe"))
      --
      --   return opts
      -- end,
      opts = {
        config_path = tostring(Path:new(nvim_data_codeium_path, "config.json")),
        bin_path = tostring(Path:new(nvim_data_codeium_path, "bin")),
      },
    },
  },
  -- copilot
  {
    {
      "hrsh7th/nvim-cmp",
      dependencies = { "zbirenbaum/copilot.lua", "zbirenbaum/copilot-cmp" },
      opts = function(_, opts)
        table.insert(opts.sources, { name = "copilot", priority = 1250, keyword_length = 1, group_index = 1 })

        local lspkind = require "lspkind"
        lspkind.symbol_map["Copilot"] = ""
        vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

        return opts
      end,
    },
    {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      enabled = true,
      event = "User AstroFile",
      opts = {
        suggestion = {
          enabled = false,
        },
        panel = {
          enabled = false,
        },
        filetypes = {
          markdown = true,
          help = true,
        },
        -- copilot_node_command = "node", -- Node.js version must be > 16.x
        server_opts_overrides = {
          trace = "verbose",
          settings = {
            advanced = {
              listCount = 10, -- #completions for panel
              inlineSuggestCount = 5, -- #completions for getCompletions
            },
          },
        },
      },
    },
    {
      "zbirenbaum/copilot-cmp",
      enabled = true,
      event = "User AstroFile",
      dependencies = {
        { "zbirenbaum/copilot.lua" },
      },
      opts = {},
    },
  },
}
