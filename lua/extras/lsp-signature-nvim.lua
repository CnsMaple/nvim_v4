vim.keymap.set(
  { "n", "i" },
  "<M-s>",
  function() require("lsp_signature").toggle_float_win() end,
  { silent = true, noremap = true, desc = "toggle signature" }
)


return {}
