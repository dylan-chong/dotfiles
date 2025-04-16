-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

---- Save/Exit ----

vim.api.nvim_exec2(
  [[
  nnoremap <C-q> :w<CR>:e<CR>
  inoremap <C-q> <Esc>:w<CR>
  nmap Q :wq<CR>

  " C-c to exit
  nnoremap <C-c> :wqa
  augroup control_c_to_exit
    autocmd!
    autocmd CmdLineEnter : nunmap <C-c>
    autocmd CmdLineLeave : nnoremap <C-c> :wqa
  augroup END
  ]],
  {}
)

---- Tabs ----

vim.keymap.set("n", "<leader>td", "<C-w>s<C-w>TgT:WintabsClose<CR>:tabnext<CR>", { desc = "Move buffer to new tab" })

vim.keymap.set("n", "<leader>tm", ":tabm<Space><C-f>a", { desc = "Move tab" })

---- Clipboard ----

function CopyPath(expand)
  local string = vim.fn.expand(expand)
  vim.fn.setreg("+", string)
  print("Copied: " .. string)
end
vim.keymap.set("n", "<leader>%", ":lua CopyPath('%:.')<Left><Left><C-f>i", { desc = "Copy file path" })

---- Complete Todos ----

function CompleteTodo()
  local current_pos = vim.fn.getpos(".")
  local current_line = vim.fn.getline(".")
  local datetime = os.date("%Y-%m-%d %H:%M:%S")

  vim.api.nvim_input('"zdd')

  -- Append the line with datetime at the beginning to the bottom
  vim.fn.append("$", "- " .. datetime .. " " .. current_line)

  -- Move the cursor back to the original position
  vim.fn.setpos(".", current_pos)
end
vim.keymap.set("n", "<leader>C", CompleteTodo, { desc = "Move tab" })
