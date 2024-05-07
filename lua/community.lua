-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

local Path = require "plenary.path"

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.git.neogit" },
  {
    "NeogitOrg/neogit",
    branch = "nightly",
  },
  { import = "astrocommunity.motion.mini-surround" },
  { import = "astrocommunity.utility.noice-nvim" },
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        -- 使用了更好的插件来完成
        signature = {
          enabled = false,
        },
        -- 优化hover
        hover = {
          enabled = true,
        },
        -- 这个是lsp加载条，会导致卡顿
        progress = {
          enabled = false,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "AutoSave: saved at " },
            },
          },
          view = "mini",
        },
        -- 这是蓝色搜索条
        -- 禁用搜索计数的虚拟文本，我有更好的
        {
          filter = {
            event = "msg_show",
            kind = "search_count",
          },
          opts = { skip = true },
        },
      },
      presets = {
        long_message_to_split = false, -- long messages will be sent to a split
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
    init = function() vim.g.lsp_handlers_enabled = false end,
  },
  { import = "astrocommunity.pack.cpp" },
  {
    "Civitasv/cmake-tools.nvim",
    -- 每一个项目都会有一个会话备份，如果打开过的项目，需要清除会话备份，才会重新启动新的默认配置
    -- 参考：https://github.com/Civitasv/cmake-tools.nvim/blob/master/docs/sessions.md
    -- unix and mac: ~/.cache/cmake_tools_nvim/
    -- windows: ~/AppData/cmake_tools_nvim/
    opts = {
      cmake_regenerate_on_save = false,
      -- cmake_build_directory = "build\\${variant:buildType}",
      cmake_build_directory = tostring(Path:new("build", "${variant:buildType}")),
      cmake_soft_link_compile_commands = false,

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
        -- "-DCMAKE_C_COMPILER:FILEPATH=D:/CodeBin/Qt/Tools/mingw1120_64/bin/gcc.exe",
        -- "-DCMAKE_CXX_COMPILER:FILEPATH=D:/CodeBin/Qt/Tools/mingw1120_64/bin/g++.exe",
        "-DCMAKE_BUILD_TYPE:STRING=Debug",
      },
    },
  },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.python" },
}
