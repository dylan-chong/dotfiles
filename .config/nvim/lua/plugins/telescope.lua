return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      layout_strategy = "fuck",
      mappings = {
        i = {
          ["<c-t>"] = require("telescope.actions").select_tab,
        },
      },
    },
  },
}
