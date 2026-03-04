return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "moon",
      on_highlights = function(hl)
        -- hl.NormalNC = { bg = "#141620" }
      end,
    },
  },
  -- {
  --   "RRethy/base16-nvim",
  --   opts = {
  --     colorscheme = "base16-summerfruit-dark",
  --   },
  --   config = function()
  --     require("base16-colorscheme")
  --   end,
  -- },
  -- {
  --   "LazyVim/LazyVim",
  --   dependencies = { "RRethy/base16-nvim" },
  --   opts = {
      -- colorscheme = "base16-summerfruit-dark",
    -- },
  -- },
}
