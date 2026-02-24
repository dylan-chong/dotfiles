-- Table alignment plugin configuration
return {
  -- vim-easy-align: Easy and fast alignment
  {
    "junegunn/vim-easy-align",
    keys = {
      -- Start interactive EasyAlign in visual mode
      { "<leader>ca", "<Plug>(EasyAlign)", mode = "x", desc = "EasyAlign" },
    },
    config = function()
      -- EasyAlign configuration
      vim.g.easy_align_delimiters = {
        -- Align by colon
        [":"] = {
          pattern = ":",
          left_margin = 1,
          right_margin = 1,
          stick_to_left = false,
        },
        -- Align by equals
        ["="] = {
          pattern = "=",
          left_margin = 1,
          right_margin = 1,
          stick_to_left = false,
        },
        -- Align by comma
        [","] = {
          pattern = ",",
          left_margin = 0,
          right_margin = 1,
          stick_to_left = true,
        },
        -- Align by pipe (for markdown tables)
        ["|"] = {
          pattern = "|",
          left_margin = 1,
          right_margin = 1,
          stick_to_left = false,
        },
        -- Align by hash (for comments)
        ["#"] = {
          pattern = "#",
          left_margin = 1,
          right_margin = 1,
          stick_to_left = false,
        },
      }
    end,
  },
}
