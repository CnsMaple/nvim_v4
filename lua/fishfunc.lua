M = {}

function M.OsCho(win, mac, linux, default)
  if vim.fn.has "win32" == 1 then
    -- 在Windows上运行的代码
    return win
  elseif vim.fn.has "unix" == 1 then
    -- 在Unix-like系统（包括Linux和macOS）上运行的代码
    if vim.fn.has "macunix" == 1 then
      -- 在macOS上运行的代码
      return mac
    else
      -- 在Linux上运行的代码
      return linux
    end
  else
    -- 在其他操作系统上运行的代码
    print "[osCho]This is an unsupported operating system."
    return default
  end
end

return M
