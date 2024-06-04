local Path = require "plenary.path"

local dap = require "dap"

dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "-i", "dap" },
}

local dap_config = {
  name = "Launch (gdb)",
  type = "gdb",
  request = "launch",
  program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
  cwd = "${workspaceFolder}",
  stopAtBeginningOfMainSubprogram = false,
}

dap.configurations.cpp = {
  dap_config,
}
dap.configurations.c = {
  dap_config,
}

return {
  {
    "cmake-tools.nvim",
    optional = true,
    enabled = false,
    opts = {
      cmake_regenerate_on_save = false,
      cmake_build_directory = "build\\${variant:buildType}",
      cmake_soft_link_compile_commands = false,

      -- 每一个项目都会有一个会话备份，如果打开过的项目，需要清除会话备份，才会重新启动新的默认配置
      -- 参考：https://github.com/Civitasv/cmake-tools.nvim/blob/master/docs/sessions.md
      -- unix and mac: ~/.cache/cmake_tools_nvim/
      -- windows: ~/AppData/Local/cmake_tools_nvim/
      -- 在vscode中的qt项目，使用cmake默认的构建参数，用来参考，请勿在CMakeLists.txt中尝试配置编译器
      -- D:\CodeBin\mingw64\bin\cmake.EXE
      -- --no-warn-unused-cli
      -- -DCMAKE_BUILD_TYPE:STRING=Debug
      -- -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE
      -- -DCMAKE_C_COMPILER:FILEPATH=D:\CodeBin\Qt\Tools\mingw1120_64\bin\gcc.exe
      -- -DCMAKE_CXX_COMPILER:FILEPATH=D:\CodeBin\Qt\Tools\mingw1120_64\bin\g++.exe
      -- -SD:/CodeData/cpp/Chess_game_QT
      -- -Bd:/CodeData/cpp/Chess_game_QT/build
      -- -G "MinGW Makefiles"
      cmake_generate_options = {
        "-DCMAKE_EXPORT_COMPILE_COMMANDS=1",
        -- 如果不想全局配gcc和g++可以在这里配置
        "-DCMAKE_C_COMPILER:FILEPATH=gcc",
        "-DCMAKE_CXX_COMPILER:FILEPATH=g++",
        "-DCMAKE_BUILD_TYPE:STRING=Debug",
      },
      cmake_runner = { -- runner to use
        name = "toggleterm", -- name of the runner
      },
      cmake_executor = { -- executor to use
        name = "toggleterm", -- name of the executor
      },
      cmake_notifications = {
        -- 运行状态，但是这个老是捕获不到
        runner = { enabled = false },
        -- 用于打印执行命令的返回结果
        executor = { enabled = true },
        spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, -- icons used for progress display
        refresh_rate_ms = 100, -- how often to iterate icons
      },
    },
  },
  -- {
  --   "Shatur/neovim-tasks",
  --   ft = fileType,
  --   -- optional = true,
  --   dependencies = {
  --     -- Ensure C/C++ debugger is installed
  --     "williamboman/mason.nvim",
  --     optional = true,
  --     opts = function(_, opts)
  --       if type(opts.ensure_installed) == "table" then
  --         vim.list_extend(opts.ensure_installed, { "codelldb", "cpptools" })
  --       end
  --     end,
  --   },
  --   init = function()
  --     -- vim.keymap.set("n", "<leader>lcd", "<Cmd>Task start cmake debug<CR>", { desc = "cpp debug" })
  --     vim.keymap.set("n", "<leader>ctd", function()
  --       require("dapui").close()
  --       vim.cmd("Task start cmake debug")
  --     end, { desc = "cpp debug" })
  --
  --     -- vim.keymap.set("n", "<leader>lcr", "<Cmd>Task start cmake run<CR>", { desc = "cpp run" })
  --     vim.keymap.set("n", "<leader>ctr", function()
  --       require("dapui").close()
  --       vim.cmd("Task start cmake run")
  --     end, { desc = "cpp run" })
  --
  --     -- vim.keymap.set("n", "<leader>lcg", "<Cmd>Task start cmake configure<CR>", { desc = "cpp config" })
  --     vim.keymap.set("n", "<leader>ctg", function()
  --       require("dapui").close()
  --       vim.cmd("Task start cmake configure")
  --     end, { desc = "cpp config" })
  --
  --     -- vim.keymap.set("n", "<leader>lcb", "<Cmd>Task start cmake build<CR>", { desc = "cpp build" })
  --     vim.keymap.set("n", "<leader>ctb", function()
  --       require("dapui").close()
  --       vim.cmd("Task start cmake build")
  --     end, { desc = "cpp build" })
  --
  --     -- vim.keymap.set("n", "<leader>lct", "<Cmd>Task set_module_param cmake target<CR>", { desc = "cpp set target" })
  --     vim.keymap.set("n", "<leader>ctt", function()
  --       require("dapui").close()
  --       vim.cmd("Task set_module_param cmake target")
  --     end, { desc = "cpp set target" })
  --   end,
  --   -- opts = function(_, opts)
  --   --   vim.keymap.set("n", "<leader>lcd", "<Cmd>CMakeDebug<CR>", { desc = "cpp debug" })
  --   --   vim.keymap.set("n", "<leader>lcr", "<Cmd>CMakeRun<CR>", { desc = "cpp run" })
  --   --   opts.default_params.cmake.args.configure = {
  --   --     "-DCMAKE_EXPORT_COMPILE_COMMANDS=1",
  --   --     "-DCMAKE_C_COMPILER:FILEPATH=D:/CodeBin/Qt/Tools/mingw1120_64/bin/gcc.exe",
  --   --     "-DCMAKE_CXX_COMPILER:FILEPATH=D:/CodeBin/Qt/Tools/mingw1120_64/bin/g++.exe",
  --   --     "-DCMAKE_BUILD_TYPE:STRING=Debug",
  --   --   }
  --   --   return opts
  --   -- end,
  --   opts = {
  --     default_params = {
  --       cmake = {
  --         build_dir = tostring(Path:new("{cwd}", "build", "{build_type}")), -- Build directory. The expressions `{cwd}`, `{os}` and `{build_type}` will be expanded with the corresponding text values. Could be a function that return the path to the build directory.
  --         -- dap_name = "codelldb",
  --
  --         -- qt的标配
  --         dap_name = "cppdbg",
  --         args = {
  --           configure = {
  --             "-DCMAKE_EXPORT_COMPILE_COMMANDS=1",
  --             "-DCMAKE_BUILD_TYPE:STRING=Debug",
  --
  --             "-DCMAKE_C_COMPILER:FILEPATH=gcc",
  --             "-DCMAKE_CXX_COMPILER:FILEPATH=g++",
  --
  --             -- use make
  --             -- require("config.fishfunc").OsCho("-G MinGW Makefiles", "", "", ""),
  --             -- "-DCMAKE_MAKE_PROGRAM=make",
  --
  --             -- use ninja
  --             "-G Ninja",
  --           },
  --         },
  --       },
  --     },
  --     save_before_run = false, -- If true, all files will be saved before executing a task.
  --     params_file = tostring(Path:new("build", "neovim.json")), -- JSON file to store module and task parameters.
  --     dap_open_command = function() end,
  --     -- dap_open_command = function() return require("dap").repl.open() end,
  --   },
  -- },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      handlers = {
        function(server, opts) require("lspconfig").qmlls.setup(opts) end,
      },
      servers = {
        "qmlls"
      },
      ---@diagnostic disable: missing-fields
      config = {
        clangd = {
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "Makefile",
              "configure.ac",
              "configure.in",
              "config.h.in",
              "meson.build",
              "meson_options.txt",
              "build.ninja",
              "CMakeLists.txt",
              "main.cpp",
              ".clangd",
              ".clang-tidy",
              ".clang-format"
            )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
              fname
            ) or require("lspconfig.util").find_git_ancestor(fname)
          end,
          cmd = {
            require("fishfunc").OsCho("clangd.exe", "clangd", "clangd", "clangd"),
            -- 主要标志
            -- "--compile-commands-dir=build/Debug/.qtc_clangd", -- qt配置编译命令文件
            -- "--compile-commands-dir=build/Debug", -- nvim的cmake配置编译命令文件
            "--compile-commands-dir=build", -- nvim的cmake配置编译命令文件
            -- "--query-driver=D:/CodeBin/Qt/Tools/mingw1120_64/bin/gcc-*.exe,D:/CodeBin/Qt/Tools/mingw1120_64/bin/g++-*.exe",

            -- 功能
            "--all-scopes-completion", -- 全代码库补全
            "--background-index",
            "--background-index-priority=normal", -- 在后台自动分析代码
            "--clang-tidy", -- 格式化代码，目录下需要放一个.clang-format文件
            "--completion-style=bundled", -- (detailed or bundled)补全的方法时候显示参数，按tab下一项的那种
            "--fallback-style=WebKit", -- webkit microsoft gun都还不错(按喜好顺序排)
            "--header-insertion=iwyu", -- (iwyu or never)禁止头文件插入
            "--header-insertion-decorators", -- 输入建议中，已包含头文件的项与还未包含头文件的项会以圆点加以区分

            -- clangd的性能
            "-j=16", -- 后台线程数，可根据机器配置自行调整
            "--pch-storage=memory", -- 用内存性能更好

            -- clangd信息
            "--log=error",
            "--pretty", -- 输出的 JSON 文件更美观
          },
        },
        -- FIX: 这里不对，没有正常启动
        qmlls = {
          -- root_dir = function(fname)
          --   return require("lspconfig.util").root_pattern(
          --     "Makefile",
          --     "configure.ac",
          --     "configure.in",
          --     "config.h.in",
          --     "meson.build",
          --     "meson_options.txt",
          --     "build.ninja",
          --     "CMakeLists.txt",
          --     "main.cpp",
          --     ".clangd",
          --     ".clang-tidy",
          --     ".clang-format"
          --   )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
          --     fname
          --   ) or require("lspconfig.util").find_git_ancestor(fname)
          -- end,
          cmd = {
            "D:/CodeBin/Qt/Tools/QtDesignStudio/qt6_design_studio_reduced_version/bin/qmlls.exe",
          },
        },
      },
    },
  },
}
