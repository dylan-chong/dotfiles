-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Autosave copied from https://github.com/LazyVim/LazyVim/discussions/1022
local function save()
  local buf = vim.api.nvim_get_current_buf()

  vim.api.nvim_buf_call(buf, function()
    vim.cmd("silent! write")
  end)
end
vim.api.nvim_create_augroup("AutoSave", {
  clear = true,
})
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  callback = function()
    save()
  end,
  pattern = "*",
  group = "AutoSave",
})
