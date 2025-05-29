return {
  "okuuva/auto-save.nvim",
  config = function()
    require("auto-save").setup({
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" },
        defer_save = {},
      },
    })
  end,
}
