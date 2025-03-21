return {
  "lmburns/lf.nvim",
  dependencies = {
    "toggleterm.nvim",
  },
  keys = {
    {
      "<leader>fl",
      function()
        require("lf").setup({})

        require("lf").start({
          height = 99999,
          width = 99999,
          winblend = 0,
        })
      end,
      desc = "lf file browser",
    },
  },
}
