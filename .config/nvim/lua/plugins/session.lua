return {
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

        " TODO add support for tab local variable storage
        ]], {})
  end,
}
