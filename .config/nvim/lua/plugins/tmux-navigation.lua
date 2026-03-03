return {
  "alexghergh/nvim-tmux-navigation",
  keys = {
    { "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>" },
    { "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>" },
    { "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>" },
    { "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>" },
  },
  config = function()
    require("nvim-tmux-navigation").setup({})
  end,
}
