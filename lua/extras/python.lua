return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    specs = {
      {
        "mfussenegger/nvim-dap-python",
        dependencies = "mfussenegger/nvim-dap",
        ft = "python", -- NOTE: ft: lazy-load on filetype
        config = function(_, opts)
          local path = vim.fn.exepath "python"
          local debugpy = require("mason-registry").get_package "debugpy"
          if debugpy:is_installed() then
            path = debugpy:get_install_path()
            if vim.fn.has "win32" == 1 then
              path = path .. "/venv/Scripts/pythonw"
            else
              path = path .. "/venv/bin/python"
            end
          end
          require("dap-python").setup(path, opts)
        end,
      },
    },
  },
}
