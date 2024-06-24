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
}
