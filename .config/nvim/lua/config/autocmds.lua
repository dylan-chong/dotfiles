-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Dim background when neovim loses focus.
-- NormalFloat is needed for snacks.nvim windows (e.g. claudecode.nvim terminal).
local FOCUSED_BG = "#1b1d2b"
local DEFOCUSED_BG = "NONE"

local function set_bg(bg)
  local normal_fg = vim.api.nvim_get_hl(0, { name = "Normal" }).fg
  vim.api.nvim_set_hl(0, "Normal", { fg = normal_fg, bg = bg })
  vim.api.nvim_set_hl(0, "NormalFloat", { fg = normal_fg, bg = bg })
end

vim.api.nvim_create_autocmd("FocusLost", {
  callback = function()
    set_bg(DEFOCUSED_BG)
  end,
})
vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    set_bg(FOCUSED_BG)
  end,
})
set_bg(FOCUSED_BG)
-- Make snacks.nvim non-current windows (e.g. claudecode) dim like regular windows
vim.api.nvim_set_hl(0, "SnacksNormalNC", { link = "NormalNC" })

vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "diff",
  callback = function()
    if vim.v.option_new == "1" then
      vim.wo.wrap = true
    end
  end,
})
