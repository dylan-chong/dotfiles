-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

--------------- Builtin plugin config ---------------

lvim.builtin.project.active = false
lvim.builtin.lir.active = false

lvim.builtin.telescope.defaults.layout_strategy = 'vertical' -- TODO see emails to fix border symbols
lvim.builtin.telescope.defaults.layout_config.height = 0.95  -- TODO change defaults in lunarvim
lvim.builtin.telescope.defaults.layout_config.width = 0.95
lvim.builtin.telescope.pickers.find_files.path_display = { "absolute" } -- TODO doesn't work

lvim.format_on_save.enabled = true

--------------- Custom plugins ---------------

lvim.plugins = {
  {
    'rmagatti/auto-session',
    config = function()
      require("auto-session").setup {}
    end,
  },

  {
    'zefei/vim-wintabs',
    config = function()
      lvim.builtin.which_key.mappings['w'] = nil -- force saves by default in lunarvim, conflicts with Wintabs <leader>w

      local line_diagnostics = lvim.lsp.buffer_mappings.normal_mode['gl']
      if line_diagnostics then
        lvim.lsp.buffer_mappings.normal_mode['gl'] = nil
        lvim.lsp.buffer_mappings.normal_mode['gK'] = line_diagnostics
      end

      vim.api.nvim_exec2([[
        let g:wintabs_ui_vimtab_name_format = '%t'
        let g:wintabs_autoclose_vim = 1
        let g:wintabs_autoclose_vimtab = 1
        let g:wintabs_autoclose = 2

        " Change buffers
        nmap gh <Plug>(wintabs_previous)
        nmap gl <Plug>(wintabs_next)

        " Other buffer stuff
        nmap <Leader>wu <Plug>(wintabs_undo)
        nmap <Leader>wm :WintabsMove<Space>
        nmap <Leader>wo <Plug>(wintabs_only)
        nnoremap <Leader>wO :tabonly<Bar>call<Space>wintabs#only()<Bar>only

        " Override q,q!,wq to avoid accidentally closing all of the buffers in the
        " tab
        function! SaveAndCloseCurrentBuffer()
          :up
        call wintabs#close()
        endfunction

        " Function to replace built in commands
        " Taken from: http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
        function! CommandCabbr(abbreviation, expansion)
          execute 'cabbr '
                \. a:abbreviation
                \. ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "'
                \. a:expansion
                \. '" : "'
                \. a:abbreviation
                \. '"<CR>'
        endfunction

        call CommandCabbr('q', 'call wintabs#close()')
        call CommandCabbr('q!', 'call wintabs#close()')
        call CommandCabbr('wq', 'call SaveAndCloseCurrentBuffer()')
      ]], {})
    end,
  },

  {
    "okuuva/auto-save.nvim",
    config = function()
      require("auto-save").setup({
        trigger_events = {
          immediate_save = { "BufLeave", "FocusLost" },
          defer_save = {},
        },
      })
    end,
  },

  { "rbgrouleff/bclose.vim" }, -- Dep of ranger.vim
  {
    "francoiscabrol/ranger.vim",
    config = function()
      vim.api.nvim_exec2([[
        let g:ranger_map_keys = 0
        let g:ranger_replace_netrw = 1
        nnoremap <leader>n :Ranger<cr>
      ]], {})
    end,
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end
  },

  {
    "hinell/lsp-timeout.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    init = function()
      vim.g.lspTimeoutConfig = {}
    end
  },
}

--------------- Custom configurations ---------------

-- File operations
vim.api.nvim_exec2([[
  nnoremap <C-q> :w<CR>
  inoremap <C-q> <Esc>:w<CR>
  nmap Q :wq<CR>

  " C-c to exit
  nnoremap <C-c> :wqa
  augroup control_c_to_exit
    autocmd!
    autocmd CmdLineEnter : nunmap <C-c>
    autocmd CmdLineLeave : nnoremap <C-c> :wqa
  augroup END
]], {})


-- Copy current file to clipboard
-- TODO NEXT just call https://github.com/tnakaz/path-to-clipboard.nvim/blob/main/lua/path-to-clipboard/init.lua
--
vim.api.nvim_exec2([[
  function! g:CopySingleLine(string)
    if executable('pbcopy')
      silent exec "!echo " . a:string . " | tr -d '\\n' | pbcopy"
    elseif executable('clip.exe')
      silent exec "!echo " . a:string . " | tr -d '\\n' | clip.exe"
    else
      echoerr 'No clipboard program found'
      throw l:output
    endif
    echom "Copied: '" . a:string . "'"
  endfunction
]], {})
lvim.builtin.which_key.mappings['%'] = { ":call CopySingleLine(expand('%'))<Left><Left><Left>", "Copy file path" }

-- Tab keys
lvim.builtin.which_key.mappings['t'] = {
  h = { "gT", "Previous tab" },
  l = { "gt", "Next tab" },
  n = { ":tabnew<Space>", "New tab" },
  c = { ":tabclose", "Close tab" },
  o = { ":tabonly<CR>", "Close other tabs" },
  m = { ":tabm<Space>", "Move tab" },
}

-- Strip ^M from recently pasted text
vim.api.nvim_command(
  "command! StripCarriageReturns %s/\r$//"
)

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.relativenumber = true
