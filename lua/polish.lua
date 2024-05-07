-- if true then return end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Set up custom filetypes
-- vim.filetype.add {
--   extension = {
--     foo = "fooscript",
--   },
--   filename = {
--     ["Foofile"] = "fooscript",
--   },
--   pattern = {
--     ["~/%.config/foo/.*"] = "fooscript",
--   },
-- }
vim.api.nvim_create_autocmd("FileType", {
  -- group = augroup("close_with_q"),
  pattern = {
    -- "PlenaryTestPopup",
    -- "help",
    -- "lspinfo",
    -- "man",
    -- "notify",
    -- "qf",
    -- "spectre_panel",
    -- "startuptime",
    -- "tsplayground",
    -- "neotest-output",
    -- "checkhealth",
    -- "neotest-summary",
    -- "neotest-output-panel",

    -- add
    "cmake_tools_terminal",
    "dap-repl",
    "dap-console",
    "dap-watches",
    "DressingInput",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- remove comment when go to next line
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "*",
  },
  callback = function()
    -- 执行指令
    vim.cmd "setlocal formatoptions-=c formatoptions-=r formatoptions-=o"
  end,
})


if vim.fn.has "win32" == 1 then
  -- 设置powsershell为默认终端
  -- https://stackoverflow.com/questions/36108950/setting-up-powershell-as-vims-shell-command-does-not-seem-to-be-passed-correct
  vim.cmd [[
            set shell=pwsh
            set shellcmdflag=-command
            set shellquote=\"
            set shellxquote=
            ]]
end
