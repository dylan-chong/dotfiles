return {
  {
    "claudecode/claudecode.nvim",
    opts = {
      terminal = {
        split_width_percentage = 0.35,
        snacks_win_opts = {
          keys = {
            nav_h = { "<C-h>", function() vim.cmd("stopinsert") vim.cmd("NvimTmuxNavigateLeft") end, mode = "t", desc = "Navigate left" },
            nav_j = { "<C-j>", function() vim.cmd("stopinsert") vim.cmd("NvimTmuxNavigateDown") end, mode = "t", desc = "Navigate down" },
            nav_k = { "<C-k>", function() vim.cmd("stopinsert") vim.cmd("NvimTmuxNavigateUp") end, mode = "t", desc = "Navigate up" },
            nav_l = { "<C-l>", function() vim.cmd("stopinsert") vim.cmd("NvimTmuxNavigateRight") end, mode = "t", desc = "Navigate right" },
          },
        },
      },
    },
  },
}
