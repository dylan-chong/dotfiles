-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

--------------- Builtin plugin config ---------------

lvim.builtin.project.active = false
lvim.builtin.lir.active = false

lvim.builtin.telescope.defaults.layout_strategy = 'vertical'
lvim.builtin.telescope.theme = nil                            -- TODO copy to lunarvim repo
lvim.builtin.telescope.defaults.path_display = { "absolute" } -- TODO add to docs on lunarvim repo
lvim.builtin.which_key.mappings['f'] = {
  function()
    require("lvim.core.telescope.custom-finders").find_project_files { previewer = true } -- TODO copy to lunarvim repo
  end,
  "Find File",
}
lvim.builtin.which_key.mappings['s']['T'] = {
  ":lua require('telescope.builtin').grep_string({ use_regex = true, search = '' })<Left><Left><Left><Left><C-f>i",
  "Text (FZF)",
}
lvim.builtin.which_key.vmappings['s'] = {
  T = {
    ":lua require('telescope.builtin').grep_string({ use_regex = true, search = '<C-r><C-w>' })<Left><Left><Left><Left><C-f>i",
    "Text (FZF)",
  }
}

lvim.format_on_save.enabled = true

--------------- Custom plugins ---------------

lvim.plugins = {
  -- Using old session plugin because it works with wintabs.
  -- In the future, will use scope.nvim and a session plugin that goes with tt
  {
    'dylan-chong/vim-session',
    dependencies = {
      'xolox/vim-misc'
    },
    config = function()
      vim.api.nvim_exec2([[
        " Settings to get it to work like vim-obsession (save session in current directory)
        let g:session_autosave_silent = 1
        let g:session_autoload = 'no'
        let g:session_autosave = 'yes'
        let g:session_lock_enabled = 0
        let g:session_directory = './'
        let g:session_default_name = 'Session'
        let g:session_autosave_periodic = 0
        let g:session_autosave_only_with_explicit_session = 1
        augroup vim_session_autosave
          au!
          au FocusLost,BufWritePost,VimLeave * silent! call xolox#session#auto_save()
        augroup END
        let g:session_persist_colors = 0
      ]], {})
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

  {
    "francoiscabrol/ranger.vim",
    dependencies = {
      "rbgrouleff/bclose.vim"
    },
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

  -- TODO - copy to lunar
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    init = function()
      local spectre = require('spectre')
      spectre.setup()
      lvim.builtin.which_key.mappings['r'] = {
        function() spectre.toggle() end,
        "Find and replace"
      }
      lvim.builtin.which_key.vmappings['r'] = {
        function() spectre.open_visual() end,
        "Find and replace"
      }
    end
  },

  -- TODO auto detect indent
  -- TODO fix auto format does not respect prettier
  -- TODO param hints
  -- TODO search visual selection
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

-- Copy file path
function CopyPath(expand)
  local string = vim.fn.expand(expand)
  vim.fn.setreg('+', string)
  print('Copied: ' .. string)
end

lvim.builtin.which_key.mappings['%'] = {
  ":lua CopyPath('%')<Left><Left><C-f>i",
  "Copy file path"
}

-- Tab keys
lvim.builtin.which_key.mappings['t'] = {
  h = { "gT", "Previous tab" },
  l = { "gt", "Next tab" },
  n = { ":tabnew<Space><C-f>a", "New tab" },
  c = { ":tabclose<C-f>a", "Close tab" },
  o = { ":tabonly<CR>", "Close other tabs" },
  m = { ":tabm<Space><C-f>a", "Move tab" },
  d = { "<C-w>s<C-w>T<Space>gh:q<CR><Space>gl", "Move buffer to new tab" },
  D = { "<C-w>s<C-w>T", "Duplicate buffer in new tab" },
}

-- Strip ^M from recently pasted text
vim.api.nvim_command(
  "command! StripCarriageReturns %s/\r$//"
)

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.relativenumber = true

-- Get command mode completion to work more nicely (TODO copy to lunarvim repo)
vim.opt.smartcase = true

-- Fix bug https://github.com/LunarVim/LunarVim/issues/3007#issuecomment-1281428877
-- TODO disable this in luanrvim
vim.api.nvim_del_augroup_by_name('_auto_resize')
