return {
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
      -- {
      --   filter = {
      --     event = "msg_show",
      --     kind = "search_count",
      --   },
      --   opts = { skip = true },
      -- },
    },
    presets = {
      long_message_to_split = false, -- long messages will be sent to a split
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
  },
  init = function() vim.g.lsp_handlers_enabled = false end,
}
