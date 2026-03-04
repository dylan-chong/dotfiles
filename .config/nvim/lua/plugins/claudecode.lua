return {
  {
    "claudecode/claudecode.nvim",
    opts = {
      terminal = {
        snacks_win_opts = {
          position = "float",
          width = 0.9,
          height = 0.9,
          border = "rounded",
          keys = {
            claude_hide = {
              "<C-,>",
              function(self)
                self:hide()
              end,
              mode = "t",
              desc = "Hide Claude",
            },
          },
        },
      },
    },
  },
}
