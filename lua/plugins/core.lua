local utils = require "astrocore"

return {
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      opts.section.header.val = {
        "███    ███  █████  ██████  ██      ███████ ",
        "████  ████ ██   ██ ██   ██ ██      ██      ",
        "██ ████ ██ ███████ ██████  ██      ███████ ",
        "██  ██  ██ ██   ██ ██      ██      ██      ",
        "██      ██ ██   ██ ██      ███████ ███████ ",
      }
      return opts
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      incremental_selection = {
        enable = true,
        keymaps = {
          -- set to `false` to disable one of the mappings
          init_selection = "<CR>",
          node_incremental = "<CR>",
          scope_incremental = "<TAB>",
          node_decremental = "<BS>",
        },
      },
      -- 可以避免一些错误的缩进
      indent = { enable = false },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require "cmp"
      opts.mapping["<C-y>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" })
      opts.mapping["<Tab>"] = nil
      opts.mapping["<S-Tab>"] = nil

      opts.mapping["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select }
      opts.mapping["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select }
      opts.mapping["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select }
      opts.mapping["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select }

      local lspkind = require "lspkind"

      opts.formatting = {
        fields = { "kind", "abbr", "menu" },
        -- fields = { "kind", "abbr"},
        format = function(entry, vim_item)
          local abbrMaxWidth = 80
          local menuMaxWidth = 20
          vim_item.kind = lspkind.symbolic(vim_item.kind, { mode = "symbol" })
          vim_item.abbr = string.sub(vim_item.abbr, 1, abbrMaxWidth)
          if vim_item.menu then vim_item.menu = string.sub(vim_item.menu, 1, menuMaxWidth) end
          return vim_item
        end,
      }

      opts["experimental"] = {
        ghost_text = true,
      }
      return opts
    end,
  },
  {
    "Weissle/persistent-breakpoints.nvim",
    event = "BufReadPost",
    opts = function(_, opts)
      return utils.extend_tbl(opts, {
        load_breakpoints_event = { "BufReadPost" },
      })
    end,
    keys = {
      {
        "<leader>db",
        function() require("persistent-breakpoints.api").toggle_breakpoint() end,
        { silent = true },
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dB",
        function() require("persistent-breakpoints.api").clear_all_breakpoints() end,
        { silent = true },
        desc = "Clear Breakpoints",
      },
      {
        "<leader>dC",
        function() require("persistent-breakpoints.api").set_conditional_breakpoint() end,
        { silent = true },
        desc = "Conditional Breakpoint",
      },
    },
  },

  {
    "rcarriga/nvim-dap-ui",
    opts = function(_, opts)
      opts.layouts = {
        {
          elements = {
            {
              id = "scopes",
              size = 0.25,
            },
            {
              id = "breakpoints",
              size = 0.25,
            },
            {
              id = "stacks",
              size = 0.25,
            },
            {
              id = "watches",
              size = 0.25,
            },
          },
          position = "right",
          size = 35,
        },
        {
          elements = {
            {
              id = "repl",
              size = 0.5,
            },
            {
              id = "console",
              size = 0.5,
            },
          },
          position = "bottom",
          size = 8,
        },
      }
      -- 文字超过窗口
      opts.expand_lines = true
      return opts
    end,
  },
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local conditions = require "heirline.conditions"
      local utils_heirline = require "heirline.utils"
      local status = require "astroui.status"
      local colors = {
        bright_bg = utils_heirline.get_highlight("Folded").bg,
        bright_fg = utils_heirline.get_highlight("Folded").fg,
        red = utils_heirline.get_highlight("DiagnosticError").fg,
        dark_red = utils_heirline.get_highlight("DiffDelete").bg,
        green = utils_heirline.get_highlight("String").fg,
        blue = utils_heirline.get_highlight("Function").fg,
        gray = utils_heirline.get_highlight("NonText").fg,
        orange = utils_heirline.get_highlight("Constant").fg,
        purple = utils_heirline.get_highlight("Statement").fg,
        cyan = utils_heirline.get_highlight("Special").fg,
        diag_warn = utils_heirline.get_highlight("DiagnosticWarn").fg,
        diag_error = utils_heirline.get_highlight("DiagnosticError").fg,
        diag_hint = utils_heirline.get_highlight("DiagnosticHint").fg,
        diag_info = utils_heirline.get_highlight("DiagnosticInfo").fg,
        git_del = utils_heirline.get_highlight("diffDeleted").fg,
        git_add = utils_heirline.get_highlight("diffAdded").fg,
        git_change = utils_heirline.get_highlight("diffChanged").fg,
      }
      -- opts.opts.colors = colors
      opts.opts.colors = utils.extend_tbl(opts.opts.colors, colors)

      local Git = {
        condition = conditions.is_git_repo,

        init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
          self.has_changes = self.status_dict.added ~= 0
            or self.status_dict.removed ~= 0
            or self.status_dict.changed ~= 0
        end,
        hl = { fg = "orange" },
        { -- git branch name
          provider = function(self) return " " .. self.status_dict.head end,
          hl = { bold = true },
        },
        -- You could handle delimiters, icons and counts similar to Diagnostics
        {
          -- condition = function(self)
          --     return self.has_changes
          -- end,
          provider = "(",
          condition = function(self)
            local count = self.status_dict.added or 0
            local count1 = self.status_dict.removed or 0
            local count2 = self.status_dict.changed or 0
            return count > 0 or count1 > 0 or count2 > 0
          end,
        },
        {
          provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and ("+" .. count)
          end,
          hl = { fg = "diag_hint" },
        },
        {
          provider = function(self)
            local count = self.status_dict.added or 0
            local count1 = self.status_dict.removed or 0
            local count2 = self.status_dict.changed or 0
            if count > 0 and (count1 > 0 or count2 > 0) then
              return " "
            else
              return ""
            end
          end,
        },
        {
          provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and ("-" .. count)
          end,
          hl = { fg = "diag_error" },
        },
        {
          provider = function(self)
            local count = self.status_dict.removed or 0
            local count2 = self.status_dict.changed or 0
            if count > 0 and count2 > 0 then
              return " "
            else
              return ""
            end
          end,
        },
        {
          provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and ("~" .. count)
          end,
          hl = { fg = "diag_warn" },
        },
        {
          -- condition = function(self)
          --     return self.has_changes
          -- end,
          provider = ")",
          condition = function(self)
            local count = self.status_dict.added or 0
            local count1 = self.status_dict.removed or 0
            local count2 = self.status_dict.changed or 0
            return count > 0 or count1 > 0 or count2 > 0
          end,
        },
      }

      local Diagnostics = {

        -- 取消这个是想要总是显示
        -- condition = conditions.has_diagnostics,

        static = {
          -- error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
          -- warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
          -- info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
          -- hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
          error_icon = " ",
          warn_icon = " ",
          info_icon = " ",
          hint_icon = " ",
        },

        init = function(self)
          self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
          self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
          self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
          self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        end,

        update = { "DiagnosticChanged", "BufEnter" },

        {
          provider = function(self)
            return (self.errors > 0 or self.warnings > 0 or self.hints > 0 or self.info > 0) and "["
          end,
          hl = function(self)
            if self.errors > 0 then
              return { fg = "diag_error" }
            elseif self.warnings > 0 then
              return { fg = "diag_warn" }
            elseif self.hints > 0 then
              return { fg = "diag_hint" }
            elseif self.info > 0 then
              return { fg = "diag_info" }
            end
          end,
        },
        {
          provider = function(self)
            -- 0 is just another output, we can decide to print it or not!
            if self.warnings > 0 or self.hints > 0 or self.info > 0 then
              return self.errors > 0 and (self.error_icon .. self.errors .. " ")
            else
              return self.errors > 0 and (self.error_icon .. self.errors)
            end
          end,
          hl = { fg = "diag_error" },
          on_click = {
            callback = function()
              vim.defer_fn(function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR } end, 100)
            end,
            name = "GoToNextDiagnosticError",
          },
        },
        {
          provider = function(self)
            if self.hints > 0 or self.info > 0 then
              return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
            else
              return self.warnings > 0 and (self.warn_icon .. self.warnings)
            end
          end,
          hl = { fg = "diag_warn" },
          on_click = {
            callback = function()
              vim.defer_fn(function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.WARN } end, 100)
            end,
            name = "GoToNextDiagnosticWarn",
          },
        },
        {
          provider = function(self)
            if self.hints > 0 then
              return self.info > 0 and (self.info_icon .. self.info .. " ")
            else
              return self.info > 0 and (self.info_icon .. self.info)
            end
          end,
          hl = { fg = "diag_info" },
          on_click = {
            callback = function()
              vim.defer_fn(function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.INFO } end, 100)
            end,
            name = "GoToNextDiagnosticInfo",
          },
        },
        {
          provider = function(self) return self.hints > 0 and (self.hint_icon .. self.hints) end,
          hl = { fg = "diag_hint" },
          on_click = {
            callback = function()
              vim.defer_fn(function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.HINT } end, 100)
            end,
            name = "GoToNextDiagnosticHint",
          },
        },
        {
          provider = function(self)
            return (self.errors > 0 or self.warnings > 0 or self.hints > 0 or self.info > 0) and "]"
          end,
          hl = function(self)
            if self.errors > 0 then
              return { fg = "diag_error" }
            elseif self.warnings > 0 then
              return { fg = "diag_warn" }
            elseif self.hints > 0 then
              return { fg = "diag_hint" }
            elseif self.info > 0 then
              return { fg = "diag_info" }
            end
          end,
        },
      }

      local LSPActive = {

        hl = { fg = "diag_hint", bold = true },
        condition = conditions.lsp_attached,
        {
          provider = " [",
        },
        {
          update = { "LspAttach", "LspDetach" },
          provider = function(self)
            local ret_table = {}
            local have_copilot = false
            for i, server in pairs(vim.lsp.get_active_clients()) do
              if server.name ~= "copilot" then
                table.insert(ret_table, server.name)
              else
                have_copilot = true
              end
            end
            local ret_str = table.concat(ret_table, " ")
            if have_copilot and string.len(ret_str) ~= 0 then ret_str = ret_str .. " " end
            return ret_str
          end,
        },
        {
          provider = "copilot",
          static = {
            copilotcolors = {
              [""] = { fg = "diag_hint" },
              ["Normal"] = { fg = "diag_hint" },
              ["Warning"] = { fg = "diag_error" },
              ["InProgress"] = { fg = "diag_warn" },
            },
          },
          -- update = function(self)
          --     local status = require("copilot.api").status.data
          --     if self.copilot_prestr ~= status then
          --         print("is update")
          --         self.copilot_prestr = status
          --         return true
          --     else
          --         -- print("is update")
          --         return false
          --     end
          -- end,

          condition = function(self)
            local ok, clients = pcall(vim.lsp.get_active_clients, { name = "copilot", bufnr = 0 })
            return ok and #clients > 0
          end,
          -- condition = function(self)
          --     if self.copilot_open then
          --         return true
          --     else
          --         return false
          --     end
          -- end,
          hl = function(self)
            return self.copilotcolors[require("copilot.api").status.data.status] or self.copilotcolors[""]
            -- return {fg = "diag_error",force = true}
          end,
        },
        {
          provider = " codeium",
          condition = function() return package.loaded["codeium"] end,
        },
        {
          provider = "]",
        },
      }

      local MacroRec = {
        condition = function() return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0 end,
        provider = " ",
        hl = { fg = "orange", bold = true },
        utils_heirline.surround({ "[", "]" }, nil, {
          provider = function() return vim.fn.reg_recording() end,
          hl = { fg = "green", bold = true },
        }),
        update = {
          "RecordingEnter",
          "RecordingLeave",
        },
      }

      local ViMode = {
        -- get vim current mode, this information will be required by the provider
        -- and the highlight functions, so we compute it only once per component
        -- evaluation and store it as a component attribute
        init = function(self)
          self.mode = vim.fn.mode(1) -- :h mode()
        end,
        -- Now we define some dictionaries to map the output of mode() to the
        -- corresponding string and color. We can put these into `static` to compute
        -- them at initialisation time.
        static = {
          mode_names = { -- change the strings if you like it vvvvverbose!
            n = "N",
            no = "N?",
            nov = "N?",
            noV = "N?",
            ["no\22"] = "N?",
            niI = "Ni",
            niR = "Nr",
            niV = "Nv",
            nt = "Nt",
            v = "V",
            vs = "Vs",
            V = "V_",
            Vs = "Vs",
            ["\22"] = "^V",
            ["\22s"] = "^V",
            s = "S",
            S = "S_",
            ["\19"] = "^S",
            i = "I",
            ic = "Ic",
            ix = "Ix",
            R = "R",
            Rc = "Rc",
            Rx = "Rx",
            Rv = "Rv",
            Rvc = "Rv",
            Rvx = "Rv",
            c = "C",
            cv = "Ex",
            r = "...",
            rm = "M",
            ["r?"] = "?",
            ["!"] = "!",
            t = "T",
          },
          mode_colors = {
            n = "red",
            i = "green",
            v = "cyan",
            V = "cyan",
            ["\22"] = "cyan",
            c = "orange",
            s = "purple",
            S = "purple",
            ["\19"] = "purple",
            R = "orange",
            r = "orange",
            ["!"] = "red",
            t = "red",
          },
        },
        -- We can now access the value of mode() that, by now, would have been
        -- computed by `init()` and use it to index our strings dictionary.
        -- note how `static` fields become just regular attributes once the
        -- component is instantiated.
        -- To be extra meticulous, we can also add some vim statusline syntax to
        -- control the padding and make sure our string is always at least 2
        -- characters long. Plus a nice Icon.
        provider = function(self) return " %2(" .. self.mode_names[self.mode] .. "%) :%5.5(%S%)" end,
        -- Same goes for the highlight. Now the foreground will change according to the current mode.
        hl = function(self)
          local mode = self.mode:sub(1, 1) -- get only the first mode character
          return { fg = self.mode_colors[mode], bold = true }
        end,
        -- Re-evaluate the component only on ModeChanged event!
        -- Also allows the statusline to be re-evaluated when entering operator-pending mode
        update = {
          "ModeChanged",
          pattern = "*:*",
          callback = vim.schedule_wrap(function() vim.cmd "redrawstatus" end),
        },
      }

      opts.statusline = { -- statusline
        hl = { fg = "fg", bg = "bg" },
        utils_heirline.surround({ "", "" }, "bright_bg", { MacroRec, ViMode }),
        -- status.component.mode(),
        -- status.component.git_branch(),
        { provider = " " },
        Git,
        status.component.file_info { filetype = {}, filename = false, file_modified = false },
        -- status.component.git_diff(),
        -- status.component.diagnostics(),
        Diagnostics,
        status.component.fill(),
        {
          condition = function()
            local session = require("dap").session()
            return session ~= nil
          end,
          provider = function() return " " .. require("dap").status() end,
          hl = "Debug",
          -- see Click-it! section for clickable actions
        },
        -- status.component.cmd_info(),
        status.component.fill(),
        -- status.component.lsp(),
        LSPActive,
        status.component.treesitter(),
        status.component.nav(),
        -- status.component.mode { surround = { separator = "right" } },
      }

      -- return the final configuration table
      return opts
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        layout_strategy = "vertical",
        layout_config = {
          vertical = {
            -- 整个窗口的高度
            height = 0.99,
            preview_cutoff = 1,
            preview_height = 0.55,
            prompt_position = "bottom",
            width = 0.9,
          },
        },
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = true,
    opts = {
      filesystem = {
        filtered_items = {
          visible = false, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false, -- only works on Windows for hidden files/directories
        },
      },
      -- renderers = {
      --   file = {
      --     { "indent" },
      --     { "icon" },
      --     {
      --       "container",
      --       width = "100%",
      --       right_padding = 1,
      --       content = {
      --         {
      --           "name",
      --           use_git_status_colors = true,
      --           zindex = 10,
      --         },
      --         { "diagnostics", zindex = 20, align = "left" },
      --         { "git_status", zindex = 20, align = "left" },
      --       },
      --     },
      --   },
      -- },
    },
  },
}
