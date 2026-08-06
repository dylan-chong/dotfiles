local function navigate_preserving_zoom(nvim_tmux_navigate_cmd)
  local was_zoomed = vim.fn.system("tmux display-message -p '#{window_zoomed_flag}'"):gsub("%s+", "") == "1"
  local pane_before = vim.fn.system("tmux display-message -p '#{pane_id}'")

  vim.cmd(nvim_tmux_navigate_cmd)

  if was_zoomed then
    local pane_after = vim.fn.system("tmux display-message -p '#{pane_id}'")
    if pane_after ~= pane_before then
      vim.fn.system("tmux resize-pane -Z")
    end
  end
end

return {
  "alexghergh/nvim-tmux-navigation",
  keys = {
    { "<C-h>", function() navigate_preserving_zoom("NvimTmuxNavigateLeft") end },
    { "<C-j>", function() navigate_preserving_zoom("NvimTmuxNavigateDown") end },
    { "<C-k>", function() navigate_preserving_zoom("NvimTmuxNavigateUp") end },
    { "<C-l>", function() navigate_preserving_zoom("NvimTmuxNavigateRight") end },
  },
  config = function()
    require("nvim-tmux-navigation").setup({})
  end,
}
