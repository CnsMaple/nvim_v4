return {
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local maps = opts.mappings
      local prefix = "<Leader>x"
      maps.n[prefix .. "s"] = { "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" }
      maps.n[prefix .. "L"] = {
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      }
    end,
  },
}
