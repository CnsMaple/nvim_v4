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

local Path = require "plenary.path"
local nvim_data_codeium_path = tostring(Path:new(vim.fn.stdpath "data", "codeium"))

return {
  -- 预览跳转
  {
    "nacro90/numb.nvim",
    event = "User AstroFile",
    enabled = true,
    opts = {
      show_numbers = true, -- Enable 'number' for the window while peeking
      show_cursorline = true, -- Enable 'cursorline' for the window while peeking
      hide_relativenumbers = true, -- Enable turning off 'relativenumber' for the window while peeking
      number_only = false, -- Peek only when the command is only a number instead of when it starts with a number
      centered_peeking = true, -- Peeked line will be centered relative to window
    },
  },
  -- 比";"更好用的插件
  { "tpope/vim-repeat", event = "User AstroFile" },
  -- 窗口移动插件
  {
    "sindrets/winshift.nvim",
    event = "User AstroFile",
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      -- options
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
      "Exafunction/codeium.nvim",
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
    {
      "CopilotC-Nvim/CopilotChat.nvim",
      branch = "canary",
      dependencies = {
        { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
        { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
        {
          "AstroNvim/astrocore",
          opts = function(_, opts)
            local maps = opts.mappings
            maps.n["<Leader>a"] = { desc = "+CopilotChat (AI)" }
            maps.v["<Leader>a"] = { desc = "+CopilotChat (AI)" }
          end,
        },
        {
          "nvim-telescope/telescope.nvim",
          optional = true,
          keys = {
            -- Show help actions with telescope
            {
              "<leader>ad",
              function()
                local actions = require "CopilotChat.actions"
                local help = actions.help_actions()
                if not help then return end
                require("CopilotChat.integrations.telescope").pick(help)
              end,
              desc = "Diagnostic Help (CopilotChat)",
              mode = { "n", "v" },
            },
            -- Show prompts actions with telescope
            {
              "<leader>ap",
              function()
                local actions = require "CopilotChat.actions"
                require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
              end,
              desc = "Prompt Actions (CopilotChat)",
              mode = { "n", "v" },
            },
          },
        },
      },
      opts = function()
        local user = vim.env.USER or "User"
        user = user:sub(1, 1):upper() .. user:sub(2)
        return {
          model = "gpt-4",
          auto_insert_mode = true,
          show_help = true,
          question_header = "  " .. user .. " ",
          answer_header = "  Copilot ",
          window = {
            width = 0.4,
          },
          selection = function(source)
            local select = require "CopilotChat.select"
            return select.visual(source) or select.buffer(source)
          end,
        }
      end,
      keys = {
        {
          "<leader>aa",
          function() return require("CopilotChat").toggle() end,
          desc = "Toggle (CopilotChat)",
          mode = { "n", "v" },
        },
        {
          "<leader>ax",
          function() return require("CopilotChat").reset() end,
          desc = "Clear (CopilotChat)",
          mode = { "n", "v" },
        },
        {
          "<leader>aq",
          function()
            local input = vim.fn.input "Quick Chat: "
            if input ~= "" then require("CopilotChat").ask(input) end
          end,
          desc = "Quick Chat (CopilotChat)",
          mode = { "n", "v" },
        },
      },
      config = function(_, opts)
        local chat = require "CopilotChat"
        local ns = vim.api.nvim_create_namespace "copilot-chat-text-hl"

        vim.api.nvim_create_autocmd("BufEnter", {
          pattern = "copilot-chat",
          callback = function(ev)
            vim.opt_local.relativenumber = true
            vim.opt_local.number = true
          end,
        })

        chat.setup(opts)
      end,
    },
  },
}
