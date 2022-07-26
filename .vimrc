" Must be first stuff
" {{{

set encoding=utf-8

let g:python3_host_prog = '/opt/homebrew/bin/python3'
let g:ruby_host_prog = '/opt/homebrew/lib/ruby/gems/3.0.0/bin/neovim-ruby-host'

" Easy leader
let mapleader=" "

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

" Disable vim-polyglot for certain filetypes
" - Liquid thinks markdown pandoc files are liquid
" - There is another plug in used for latex
let g:polyglot_disabled = ['liquid', 'latex']
let g:vim_markdown_conceal = 0

" }}}



" Vim-Plug
" {{{

call plug#begin('~/.vim/plugged')

" PLUGINS GO HERE
" {

" Themes
Plug 'danielwe/base16-vim'

" CTags
" Plug 'ludovicchabant/vim-gutentags'

" NERDTree
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Ranger
Plug 'francoiscabrol/ranger.vim'
if has('nvim')
  Plug 'rbgrouleff/bclose.vim'
endif

" File-related stuff
Plug 'dylan-chong/far.vim', { 'branch': 'rg-git-ignore-but-break-globbing' }
Plug 'tpope/vim-eunuch'

" FZF
set rtp+=/opt/homebrew/opt/fzf
Plug 'junegunn/fzf.vim'
Plug 'tweekmonster/fzf-filemru'
Plug 'dylan-chong/fzf_similar.vim', { 'branch': 'develop' }

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Space/indenting
Plug 'tweekmonster/wstrip.vim' " Strip whitespace from lines changed
Plug 'ntpeters/vim-better-whitespace' " Used only for :StripWhitespace

" Low level editing
Plug 'dhruvasagar/vim-table-mode'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'scrooloose/nerdcommenter'
Plug 'godlygeek/tabular' " Space out code into tables
Plug 'PeterRincker/vim-argumentative'

" Language packs
Plug 'sheerun/vim-polyglot'
Plug 'mxw/vim-prolog'

" Linting
" Plug 'w0rp/ale'

" LSP
" Language client is not really well maintained
" Plug 'autozimu/LanguageClient-neovim', {
      " \ 'branch': 'next',
      " \ 'do': 'bash install.sh',
      " \ }
" Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'neoclide/coc.nvim', { 'branch': 'release', 'on': [] }

" Completion
" TODO remove all these plugins
" Plug 'ervandew/supertab' " Disabled because of coc
" if has('nvim')
  " Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
  " Plug 'Shougo/deoplete.nvim'
  " Plug 'roxma/nvim-yarp'
  " Plug 'roxma/vim-hug-neovim-rpc'
" endif

" Lilypond
Plug 'gisraptor/vim-lilypond-integrator'

" PlantUML
Plug 'aklt/plantuml-syntax'
Plug 'weirongxu/plantuml-previewer.vim'

" Javascript
Plug 'Galooshi/vim-import-js'

" Wintabs (must be after vim-airline)
Plug 'zefei/vim-wintabs'
Plug 'zefei/vim-wintabs-powerline'

" REPL
Plug 'metakirby5/codi.vim'

" Session
Plug 'xolox/vim-misc' " Required by vim-session
Plug 'dylan-chong/vim-session'

" Miscellaneous
Plug 'tyru/open-browser.vim' " Required by plantuml-previewer.vim
Plug 'arecarn/vim-crunch' " Evaluate maths expressions
Plug 'RRethy/vim-illuminate' " Highlight uses of the word under the cursor on screen
Plug 'ap/vim-css-color' " Highlight css colours
Plug 'tpope/vim-abolish' " 3 unrelated plugins
if !has('nvim')
  Plug 'wincent/terminus' " Improve cursor look, mouse support, focus reporting
endif
Plug 'junegunn/vim-peekaboo' " Show register contents
Plug 'Yggdroot/indentLine' " Show indenting columns
Plug 'terryma/vim-multiple-cursors'
Plug 'vim-scripts/listmaps.vim' " Find where mappings are coming from

" Text objects
Plug 'kana/vim-textobj-user'
Plug 'andyl/vim-textobj-elixir'
Plug 'Julian/vim-textobj-variable-segment'

" }

call plug#end()

" }}}



" Coloring
" {{{

" General
syntax on
let g:enable_bold_font = 1

" Colorscheme
set background=dark
let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-material-palenight
" These make base16-material-palenight look better
highlight clear LineNr

" Highlight line/column
" set cursorline

" End column
hi ColorColumn ctermbg=52
" Highlight only if there is a character on the column
cal matchadd('ColorColumn', '\%81v', 100)

" vim-illuminate
hi illuminatedWord ctermbg=15 guibg=#3B4750

" }}}



" Plugin Config
" {{{

" Far.vim
let g:far#source = 'rgnvim'
let g:far#debug = 1
let g:far#enable_undo = 1
" TODO replace with CocSearch
nnoremap <Leader>vr "xyiw:w<Space><Bar><Space>Far <C-r>x<Space><Space>*<Left><Left>
vnoremap <Leader>vr "xy:w<Space><Bar><Space>Far <C-r>x<Space><Space>*<Left><Left>

" Vim Airline Plugin
let g:airline_detect_modified=0
let g:airline_powerline_fonts=1
let g:airline_section_x = ''
let g:airline_section_z = '%3v'
let g:airline_detect_spell=0
let g:airline_detect_spelllang=0
let g:airline_detect_paste=1
let g:airline#extensions#hunks#enabled = 0
set laststatus=2 " Always show status line

" Deoplete
let g:deoplete#enable_ignore_case = 1
let g:deoplete#auto_complete_start_length = 1
" let g:deoplete#enable_at_startup = 1 " TODO disabled while I try out coc.nvim
let g:deoplete#enable_at_startup = 0
" TODO disabled for now cos high cpu usage when typing, cant remember why it was set to 1 cos haven't looked at this url
" call deoplete#custom#option('num_processes', 1) " Temporary workaround https://github.com/Shougo/deoplete.nvim/issues/761#issuecomment-389701983

" Nerd Commenter
" let g:NERDDefaultAlign = 'start'
let g:NERDRemoveExtraSpaces = 0
let g:NERDTrimTrailingWhitespace = 1
let g:NERDSpaceDelims = 1
nmap gc <leader>c<space>
vmap gc <leader>c<space>
nmap gC <leader>cs
vmap gC <leader>cs

" Supertab
" let g:SuperTabDefaultCompletionType = "<c-n>"

" Alchemist
let g:alchemist#elixir_erlang_src = '~/.elixir-completion/'
" let g:alchemist_tag_disable = 0 " It is broken at the moment

" AutoPairs
let g:AutoPairsMapSpace = 1
let g:AutoPairsMultilineClose = 0
" let g:AutoPairs = {
      " \ '`': '`',
      " \ '"': '"',
      " \ '{': '}',
      " \ '''': '''',
      " \ '(': ')',
      " \ '[': ']',
      " \ '<%': '%>',
      " \ }
let g:AutoPairsShortcutJump = ''
let g:AutoPairsShortcutToggle = ''

" Ale
" let g:ale_completion_enabled = 1
" let g:ale_set_signs = 1
" let g:ale_change_sign_column_color = 0
" let g:ale_sign_column_always = 0
" let g:ale_completion_delay = 500
" let g:ale_linters = {
      " \ 'java': [],
      " \ 'typescript': ['eslint'],
      " \ 'ruby': ['rubocop'],
      " \ 'elixir': ['mix', 'credo'],
      " \ }
" " Turn linting errors into warnings
" let g:ale_type_map = {
      " \ 'eslint': {'ES': 'WS', 'E': 'W'},
      " \ 'credo': {'ES': 'WS', 'E': 'W'}
      " \ }
" let g:ale_fixers = {
      " \ 'typescript': ['eslint'],
      " \ 'typescriptreact': ['eslint', 'tslint'],
      " \ 'javascript': ['eslint'],
      " \ 'python': ['autopep8'],
      " \ 'ruby': ['rubocop'],
      " \ 'elixir': ['mix_format'],
      " \ }
" let g:ale_typescript_tslint_use_global = 0
" let g:ale_elixir_credo_use_global = 0
" let g:ale_lint_on_enter = 0
" nnoremap <leader>an :ALENextWrap<CR>
" nnoremap <leader>ap :ALEPreviousWrap<CR>
" nnoremap <leader>ad :ALEGoToDefinition<CR>
" nnoremap <leader>af :ALEFix<CR>

" Import JS
nnoremap <leader>jj :ImportJSWord<CR>
nnoremap <leader>jf :ImportJSFix<CR>

" Better Whitespace
let g:better_whitespace_enabled = 0

" Git Gutter
set updatetime=300
nmap [h <Plug>(GitGutterPrevHunk)
nmap ]h <Plug>(GitGutterNextHunk)
let g:gitgutter_preview_win_floating = 0
" Looks better with base16_material-palenight TODO not doing anything
" highlight link hl-SignColumn NonText

" PlantUML Previewer
augroup plantuml_previewer_config
  au!
  au FileType plantuml let g:plantuml_previewer#plantuml_jar_path =
        \ substitute(
        \   system("cat `which plantuml` | grep 'plantuml.jar' | perl -pe 's/.* (\\S+plantuml\\.jar).*/\\1/'"),
        \   '\n', '', 'g'
        \ )
augroup END
let g:plantuml_previewer#plantuml_jar_path = '/usr/local/Cellar/plantuml/1.2018.3/libexec/plantuml.jar'

" Markdown (part of polyglot)
" Hack to fix bullet point problem (https://github.com/plasticboy/vim-markdown/issues/232)
autocmd FileType markdown
    \ set formatoptions-=q |
    \ set formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^\\s*\[-*+]\\s\\+
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0

" Fugitive (Git)
nnoremap <Leader>gb :w<CR>:Git blame<CR>
nnoremap <Leader>gs :tabnew <Bar> terminal bash --login<CR>Ags<CR>
nnoremap <Leader>ga :wa<CR>:Git add %

" Win Tabs
let g:wintabs_ui_vimtab_name_format = '%t'
let g:wintabs_autoclose_vim = 1
let g:wintabs_autoclose_vimtab = 1
let g:wintabs_autoclose = 2
if !has('idea')
  " Change tabs
  nnoremap <Leader>gh gT
  nnoremap <Leader>g<Left> gT
  nnoremap <Leader>gl gt
  nnoremap <Leader>g<Right> gt

  " Change buffers
  nmap gh <Plug>(wintabs_previous)
  nmap g<Left> <Plug>(wintabs_previous)
  nmap gl <Plug>(wintabs_next)
  nmap g<Right> <Plug>(wintabs_next)

  " Other buffer stuff
  nmap <Leader>wu <Plug>(wintabs_undo)
  nmap <Leader>wm :WintabsMove<Space>
  nmap <Leader>wo <Plug>(wintabs_only)
  nnoremap <Leader>wO :tabonly<Bar>call<Space>wintabs#only()<Bar>only

  " Copied from https://github.com/zefei/vim-wintabs/issues/47#issuecomment-451717800
  function! WintabsCloseRight()
    call wintabs#refresh_buflist(0)
    let buflist = copy(w:wintabs_buflist)
    call filter(buflist, 'v:key > '.index(buflist, bufnr('%')))
    " 'v:key < ' for all tabs to the left
    for buffer in buflist
      execute 'buffer! '.buffer
      WintabsClose
    endfor
  endfunction
  :command WintabsCloseRight call WintabsCloseRight()
  nnoremap <Leader>wcl :call WintabsCloseRight()<CR>
  nnoremap <Leader>wc<Right> :call WintabsCloseRight()<CR>

  " Override q,q!,wq to avoid accidentally closing all of the buffers in the
  " tab
  function! SaveAndCloseCurrentBuffer()
    :up
    call wintabs#close()
  endfunction
  call CommandCabbr('q', 'call wintabs#close()')
  call CommandCabbr('q!', 'call wintabs#close()')
  call CommandCabbr('wq', 'call SaveAndCloseCurrentBuffer()')

  " Override enuch's Delete command to not close the current window, close the
  " current win tab instead
  function! DeleteCurrentFile()
    call delete(expand('%'))
    call wintabs#close()
  endfunction
  autocmd VimEnter * command! Delete call DeleteCurrentFile()
endif
" Show git commit file in tabline
let g:wintabs_ignored_filetypes = []
autocmd FileType gitcommit set buflisted
" Fix this plugin overriding the styling for vim-airline
call g:Base16hi(
      \ 'TablineSel',
      \ g:base16_gui00,
      \ g:base16_gui0D,
      \ g:base16_cterm00,
      \ g:base16_cterm0D,
      \ 'bold',
      \ ''
      \ )
call g:Base16hi(
      \ 'Tabline',
      \ g:base16_gui04,
      \ g:base16_gui02,
      \ g:base16_cterm04,
      \ g:base16_cterm02,
      \ '',
      \ ''
      \ )
let g:wintabs_powerline_sep_buffer = ''
let g:wintabs_powerline_sep_tab = ''
" Reinitialise when reloading vimrc to make it look right
call wintabs_powerline#init()
function! TabCloseRight(bang)
    let cur=tabpagenr()
    while cur < tabpagenr('$')
        exe 'tabclose' . a:bang . ' ' . (cur + 1)
    endwhile
endfunction
function! TabCloseLeft(bang)
    while tabpagenr() > 1
        exe 'tabclose' . a:bang . ' 1'
    endwhile
endfunction
command! -bang TabCloseRight call TabCloseRight('<bang>')
command! -bang TabCloseLeft call TabCloseLeft('<bang>')

" Vim Session
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

" Gutentags (TODO can remove this plugin?)
" rg respects gitignore files. This command also filters out certain file types
" that we do not want tags for
" let g:gutentags_file_list_command = "rg -l '.' | rg -v '(md|json|plist)$'"
" let g:gutentags_define_advanced_commands = 1

" FZF
let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.9, 'yoffset': 1, 'border': 'rounded' } }
" FZF File MRU
let g:fzf_filemru_bufwrite = 1
augroup custom_filemru
  autocmd!
  autocmd BufEnter * UpdateMru
  " autocmd BufLeave * UpdateMru
augroup END
" An action can be a reference to a function that processes selected lines
function! s:fzf_build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction
function! s:fzf_open_buffers(lines)
  for file_name in a:lines
    execute 'e ' . fnameescape(file_name)
    WintabsRefresh
  endfor
endfunction
let g:fzf_action = {
      \ 'enter': function('s:fzf_open_buffers'),
      \ 'ctrl-q': function('s:fzf_build_quickfix_list'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit',
      \ }
nnoremap <silent> <Leader>f :call fzf#vim#files('', fzf#vim#with_preview('right'))<CR>
nnoremap <silent> <Leader>F :ProjectMru --tiebreak=end<cr>
nnoremap <silent> <Leader><C-f>1 :call fzf_similar#find_similar_files()<CR>
nnoremap <silent> <Leader><C-f>2 :call fzf_similar#find_similarly_named_files()<CR>
nnoremap <silent> <Leader><C-f>3 :call fzf_similar#find_files_in_the_same_directory()<CR>
nnoremap <silent> <Leader>zg :GFiles?<CR>
nnoremap <silent> <Leader>zc :Commands<CR>
nnoremap <silent> <Leader>zb :Buffers<CR>
nnoremap <silent> <Leader>zt :Tags<CR>
nnoremap <silent> <Leader>zl :BLines<CR>
nnoremap <silent> <Leader>z/ :History/<CR>
nnoremap <silent> <Leader>z: :History:<CR>
nnoremap <silent> <Leader>zh :Helptags<CR>
nnoremap <silent> <Leader>zm :Maps<CR>
nnoremap <Leader>r :Rg<Space>
nnoremap <Leader>R :Rg<Space><C-r><C-w>
vnoremap <Leader>r "ry:Rg<Space><C-r>r
vnoremap <Leader>R "ry:Rg<Space><C-r>r
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   "rg --column --line-number --no-heading --color=always --smart-case --multiline -g '!.git' --hidden ".shellescape(<q-args>), 1,
      \   fzf#vim#with_preview('right:35%'),
      \   <bang>0)
cnoreabbrev rg Rg

" Codi
let g:codi#rightalign = 0
let g:codi#width = 70
let g:codi#interpreters = {
      \   'python': {
      \     'bin': 'python3',
      \     'prompt': '^\(>>>\|\.\.\.\) ',
      \   }
      \ }

" WStrip
" Globally enabled for all filetypes
let g:wstrip_auto = 1

" LanguageClient neovim
" set hidden " Required for operations modifying multiple buffers like rename.
" let g:LanguageClient_serverCommands = {
      " \ 'typescript': ['typescript-language-server', '--stdio'],
      " \ 'typescriptreact': ['typescript-language-server', '--stdio'],
      " \ }
" let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
" let g:LanguageClient_loggingLevel = 'INFO'
" let g:LanguageClient_serverStderr = '/tmp/LanguageServer.log'
" let g:LanguageClient_windowLogMessageLevel = 'Error'
" let g:LanguageClient_diagnosticsList = 'Disabled'
" nnoremap <Leader>ll :call LanguageClient_contextMenu()<CR>
" nnoremap <Leader>ld :call LanguageClient#textDocument_definition()<CR>
" nnoremap <Leader>la :call LanguageClient#textDocument_codeAction()<CR>
" nnoremap <Leader>lr <C-w>s<C-w>T:call LanguageClient#textDocument_rename()<CR>

" NERDTree
let NERDTreeShowLineNumbers=1 " enable line numbers
autocmd FileType nerdtree setlocal relativenumber
let NERDTreeShowHidden=1
let g:NERDTreeWinSize=45
let g:NERDTreeHijackNetrw = 0


" Ranger
let g:ranger_map_keys = 0
let g:ranger_replace_netrw = 1
nnoremap <leader>n :Ranger<cr>

" coc.nvim
let g:node_client_debug = 1
let g:has_initialised_coc = 0
function! s:init_coc()
  if g:has_initialised_coc
    return
  endif
  let g:has_initialised_coc = 1
  call plug#load('coc.nvim')

  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')
  " if hidden is not set, TextEdit might fail.
  set hidden
  " Use <c-space> to trigger completion.
  inoremap <silent><expr> <c-space> coc#refresh()

  " Use tab for trigger completion with characters ahead and navigate.
  " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  " other plugin before putting this into your config.
  " https://github.com/neoclide/coc-snippets version
  " inoremap <silent><expr> <TAB>
      " \ pumvisible() ? coc#_select_confirm() :
      " \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      " \ <SID>check_back_space() ? "\<TAB>" :
      " \ coc#refresh()
  inoremap <silent><expr> <C-b>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "" :
      \ coc#refresh()
  " Original one
  inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction
  " Use <c-space> to trigger completion.
  inoremap <silent><expr> <c-space> coc#refresh()

  " Use `[g` and `]g` to navigate diagnostics
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)
  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>
  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction
  " Use `:Format` to format current buffer
  command! -nargs=0 Format :call CocAction('format')
  " use `:OR` for organize import of current buffer
  command! -nargs=0 OrganiseImport :call CocAction('runCommand', 'editor.action.organizeImport')
  " Remap keys for gotos
  nmap <silent> <leader>ld <Plug>(coc-definition)
  nmap <silent> <leader>lD <Plug>(coc-type-definition)
  nmap <silent> <leader>li <Plug>(coc-implementation)
  nmap <silent> <leader>lr <Plug>(coc-references)
  " Using CocList
  " Show all errors
  nnoremap <silent> <leader>le  :<C-u>CocList --auto-preview diagnostics<cr>
  " Show commands
  nnoremap <silent> <leader>lc  :<C-u>CocList commands<cr>
  " Show list
  nnoremap <silent> <leader>ll  :<C-u>CocList --auto-preview<cr>
  " Reshow list
  nnoremap <silent> <leader>lL  :CocListResume<cr>
  " Find symbol of current document
  nnoremap <silent> <leader>lo  :<C-u>CocList --auto-preview outline<cr>
  nnoremap <silent> <leader>lO  :<C-u>CocCommand workspace.showOutput<cr>
  " Search workspace symbols
  nnoremap <silent> <leader>lt  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  nnoremap <silent> <leader>lj  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <silent> <leader>lk  :<C-u>CocPrev<CR>
  " Resume latest coc list
  " nnoremap <silent> <leader>lp  :<C-u>CocListResume<CR>
  " Work with monorepos
  " Disable automatic detection of projects
  let g:coc_root_patterns = ['.vim']
  autocmd FileType * let b:coc_root_patterns = g:coc_root_patterns
  " let g:WorkspaceFolders = ['/Users/Dylan/Development/solve/solvedata/solve/api/src/']
endfunction
autocmd! InsertEnter * call <SID>init_coc()

" vim-peekaboo
let g:peekaboo_window = 'vert bo new'
let g:peekaboo_delay = 50 " Don't bring up the window if dragon is typing in a sequence of characters quickly

" indentLine
set conceallevel=1
set concealcursor=n
let g:indentLine_concealcursor = &concealcursor
let g:indentLine_conceallevel = &conceallevel
" Exclude markdown because we don't want to conceal the code blocks and whatnot
let g:indentLine_fileTypeExclude = ['markdown']
autocmd FileType markdown setlocal conceallevel=0 | setlocal concealcursor=


" vim-multiple-cursors
let g:multi_cursor_select_all_word_key = '<M-n>'
let g:multi_cursor_select_all_key      = 'g<M-n>'

" vim-illuminate
let g:Illuminate_delay = 50

" }}}



" Key mappings
" {{{

" Clear highlighting
if !has('nvim') && !has('idea') && !has("gui_running")
  " Is normal vim. escape mappings break it:
  " https://github.com/vim/vim/issues/3080#issuecomment-399738110
else
  nnoremap <silent> <esc> <esc>:noh<cr>
  inoremap <silent> <esc> <esc>:noh<cr>
endif

" Splitting lines
nnoremap <C-j> i<CR><ESC>

" Emacs style moving to the end and start of line
inoremap <C-a> <Esc>I
inoremap <C-e> <Esc>A

" Wrap paragraph
nnoremap gwp gwip^

" Save one keystroke when aligning code
nnoremap =p mz=ap`z

" Whole file operatoins
nnoremap yaf mzggVGy`z
nnoremap daf mzggVGd`z
nnoremap =af mzggVG=`z
vnoremap af mzgg0oG$

" Replace (a (local) variable name)
" Part 1: Yank current selection (for example a variableName)
vnoremap <C-k> "xyV
" Part 1.1: (Optional variant of part 1 - select current word)
nnoremap <C-k> viw"xyV
" Part 2: Start the search with the template (containing variableName as a
" search term and replaced term), in the selected range. Assumes gdefault is
" on. You can optionally type <C-r>x to paste what we are going to replace. You
" can also adjust the selection area after pressing <C-r> by pressing
" <ESC>gvADJUST_YOUR_SEARCH_AREA_NOW:<Up>.
vnoremap <C-r> :s@\C\V\<<C-r>x\>@
" Part 2.1: Start the search without the end and start of word match
vnoremap g<C-r> :s@\C\V<C-r>x@
" Part 2.2: Use abolish.vim Substitute
vnoremap g<C-u> :S@<C-r>x@

" Reload .vimrc
nnoremap <leader>sv :w<CR>:so $MYVIMRC<CR>

" Exporting documents
nnoremap <Leader>ed :saveas ~/Desktop/
nnoremap <Leader>dt :w<CR>:!pdflatex '%' && open %:r.pdf<CR>

" 'Inspections'
" {{{
" Split list/params by comma (except trailing comma)
vnoremap <leader>i, mz:s/,\(\s*$\)\@\!/,\r<CR>=ap`z
" Put a new line at the start and end of the selection
vmap <leader>i<C-j> <ESC><Right><C-j>gvo<ESC><C-j>
" Split params by comma and start/end of selection (Doesnt work if nested method calls)
vmap <leader>i<CR> <leader>i<C-j>V<leader>i,
" Same as above, but selects automatically
nmap <leader>i<CR> v%<Right>o%%<Left><leader>i<CR>
" Same as above, but doesn't split by comma
nmap <leader>i<C-j> v%<Right>o%%<Left><leader>i<C-j>
" Split line into multiple lines by '.'
vnoremap <leader>i. :s/\./\r\.<CR><ESC>mz=ap`z
" }}}

" Don't deselect text on indent
vnoremap < <gv
vnoremap > >gv

" Move buffers into splits
" Doesn't work - probably due to race condition? :(
" nnoremap g<C-w>s <C-w>s<C-w><C-p>:q<CR><C-w><C-p>
" nnoremap g<C-w>v <C-w>v<C-w><C-p>:q<CR><C-w><C-p>

" Switch to last tab
let g:lasttab = 1
nnoremap <Leader>gt :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Toggling options
nnoremap <leader>oa :set formatoptions+=a<CR>
nnoremap <leader>oA :set formatoptions-=a<CR>
nnoremap <leader>ow :set wrap<CR>
nnoremap <leader>oW :set nowrap<CR>
nnoremap <leader>oF :set filetype=
nnoremap <leader>ofp :set filetype=python<CR>
nnoremap <leader>ofj :set filetype=javascript<CR>
nnoremap <leader>ofe :set filetype=elixir<CR>
nnoremap <leader>ofr :set filetype=ruby<CR>
nnoremap <leader>ofm :set filetype=markdown<CR>
nnoremap <leader>ofs :set filetype=sql<CR>
nnoremap <leader>omR :set makeprg=rubocop\ -f\ e<CR>

" Select recently pasted text
nnoremap gp `[v`]

" Select current line except whitespace
nnoremap gV ^v$<Left>

" Copy current file to clipboard
" TODO Use a plugin and instead of making the function myself
function! g:CopySingleLine(string)
  silent exec "!echo " . a:string . " | tr -d '\\n' | pbcopy"
  echom "Copied: '" . a:string . "'"
endfunction
nnoremap <Leader>% :call CopySingleLine(expand('%'))<Left><Left><Left>

" File operations
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

" Change case of first letter of current word in insert mode
inoremap <C-b>b <Esc>mzviwo<Esc>~`za
inoremap <C-b>B <Esc>mzviWo<Esc>~`za

" Change case of current word in insert mode
inoremap <C-b>u <Esc>mzguiw`za
inoremap <C-b>U <Esc>mzgUiw`za

" Delete variable segment (depends on Julian/vim-textobj-variable-segment)
imap <M-BS> <Esc>vivs

" Place cursor on the tag when jumping to it
" (https://vi.stackexchange.com/a/16679/11136)
func! ModifiedTagJump()
  " remember the WORD under the cursor and do the tag jump
  let tag_word = expand('<cword>')
  exec "norm! \<C-]>"

  let landed_word = expand('<cword>')
  if tag_word != landed_word
    let curpos = getcurpos()
    let curline = curpos[1]
    let curcol = curpos[2]

    " Look for tag_word as a standalone string on the current
    " line (it shouldn't be a sub-string)
    let srchres = searchpos("\\<" . tag_word . "\\>", 'zn')

    if srchres[0] == curline && srchres[1] > curcol
      " A match. Move the cursor forward.
      exec "norm! " . srchres[1] . "|"
    endif
  endif
endfunc
nnoremap <C-]> :call ModifiedTagJump()<CR>

" Unpop tag stack
nnoremap <silent> <C-\> :tag<CR>

" Tab
nnoremap <Leader>Tn :tabnew<Space>
nnoremap <Leader>Tc :tabclose
nnoremap <Leader>To :tabonly<CR>
nnoremap <Leader>Tm :tabm<Space>

" Duplicate buffer in new tab and close original
nmap <Leader>Td <C-w>s<C-w>T<Space>gh:q<CR><Space>gl
" Duplicate buffer in new tab
nnoremap <Leader>TD <C-w>s<C-w>T

" Maximise window
nnoremap <C-w>+ <C-w>_<C-w><Bar>

" Goto start of line in command mode (make going to the end and start of lines
" consistent with terminal emacs shortcuts)
cnoremap <C-a> <C-b>

" Location list window / make
" (Also see 'Toggling options' for makeprg mappings)
nnoremap <Leader>mm :lmake <Bar> lclose <Bar> lwindow<CR>
nnoremap <Leader>mw :lwindow<CR>
nnoremap ]l :lnext<CR>
nnoremap [l :lprevious<CR>
" Quick fix window regions of above commands
nnoremap <Leader>qm :make <Bar> cclose <Bar> cwindow<CR>
nnoremap <Leader>qw :cwindow<CR>
nnoremap ]q :cnext<CR>
nnoremap [q :cprevious<CR>

" Yank as one line
vmap gy JgVyu

" Don't clear clipboard when pressing S
nnoremap S "zS

" Turn function call into a pipe (mostly)
nmap <Leader>t<Bar> ^f(vi,"xdBi<Bar>><Space><Esc>:s/\(<Bar>><Space>[a-zA-Z0-9._]\+\)(,\s\?/\1(/e<CR>O<C-r>x<Esc>
" Cut first argument: ^f(vi,"xd
" Insert pipe operator at start of line: I<Bar>><Space><Esc>
" Replace (, with ( if it is present: :s/\(<Bar>><Space>[a-zA-Z0-9._]\+\)(,\?\s\?/\1(<CR>
" Paste argument above O<C-r>x<Esc>

" Turn a pipe call into not a pipe call
nmap <Leader>t( kgV"xddddwf("xpa,<Space><Esc>^:s/, )$/)/e<CR>j
" Cut the contents of the line above and then delete the entire line: kgV"xddd
" Delete the pipe and move cursor: dwf(
" Paste the contents of the line we deleted: "xp
" Add comma to separate arguments: ,<Space><Esc>
" Remove the comma if it's unnecessary: ^:s/, )$/)/e
" Move the cursor into the right place to run the macro again: <CR>j

" }}}



" Gui Vims
" {{{

if has("gui_running")
  " MacVim
  set guifont=Fira\ Code\ Light:h13
  set linespace=4
endif

" }}}



" Other
" {{{

" Scroll off
set scrolloff=4
set sidescrolloff=4

" Mouse scrolling speed
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>
" Modified version of
" https://github.com/neovim/neovim/issues/6211#issuecomment-537344220
noremap <2-ScrollWheelUp> <C-Y><C-Y>
noremap <3-ScrollWheelUp> <C-Y><C-Y><C-Y>
noremap <4-ScrollWheelUp> <Nop>
noremap <2-ScrollWheelDown> <C-E><C-E>
noremap <3-ScrollWheelDown> <C-E><C-E><C-E>
noremap <4-ScrollWheelDown> <Nop>

" Text width
set textwidth=79
autocmd FileType elixir,sql
      \ setlocal textwidth=98

" Don't wrap on typing
set formatoptions-=t

" Indenting defaults
" Defaults to 4 spaces for most filetypes
if get(g:, '_has_set_default_indent_settings', 0) == 0
  autocmd FileType typescript,javascript,jsx,tsx,scss,css,html,json,ruby,elixir,kotlin,vim,tmux,plantuml,sql
        \ setlocal expandtab tabstop=2 shiftwidth=2
  " setglobal seems to not override sleuth when reloading vimrc
  set expandtab
  set tabstop=4
  set shiftwidth=4
  let g:_has_set_default_indent_settings = 1
endif

" Line Numbers
set relativenumber
set number

" Somehow maybe gets the Mac clipboard to work
set clipboard=unnamed

" Backspace fix
set backspace=2

" Odd filetypes/extensions
au BufRead,BufNewFile *.js.applescript set filetype=javascript
au BufRead,BufNewFile *.L42 set filetype=L42
au FileType L42 setlocal nocindent nosmartindent indentexpr= syntax=swift

" Markdown bullet indenting
set autoindent

" Command completion
set wildmode=longest:full,full

" Remove scrollbars on guis
set guioptions-=L " split
set guioptions-=R " split
set guioptions-=r

" Disable continuing comments on new lines
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Autosave
au FocusLost,BufLeave * silent! :wa
" Autosave when doing some actions
set autowrite
set autowriteall

" Auto reload
set autoread
au FocusGained,BufEnter * :silent! checktime " Taken from https://stackoverflow.com/a/2329094/1726450

" Tags
set tags=./tags;

" Don't wrap long lines onto the next line on the screen
set nowrap

" If wrapping, indent wrapped lines
set breakindent
set breakindentopt=shift:2

" Round indents if starting with a space
set shiftround

" No double space after running `gq` on a line with a '.' at the end
set nojoinspaces

" Get bg color to work in tmux
set t_ut=

" Colors in neovim
set termguicolors

" No swapfiles
set nobackup noswapfile

" Mouse
set mouse=a

" Redraw faster
set lazyredraw

" Spelling
setglobal spelllang=en_nz
set dictionary+=/usr/share/dict/words
autocmd FileType markdown,text,bib,latex,tex setlocal spell

" Export plantuml
function! g:PlantUMLSave()
  exec "!plantuml -headless " . expand('%') . " &"
endfunction
command! PlantUMLSave silent call g:PlantUMLSave()

" Open image plantuml saved by PlantUMLSave
function! g:PlantUMLOpenImage()
  exec "!open " . expand('%:p:r') . ".png"
endfunction
command! PlantUMLOpenImage silent call g:PlantUMLOpenImage()

" Case (and ignore case in command mode)
set ignorecase
set smartcase
augroup dynamic_smartcase
  autocmd!
  autocmd CmdLineEnter : set nosmartcase
  autocmd CmdLineLeave : set smartcase
augroup END

" Don't wrap in the middle of a word
set linebreak

" Highlight search results
set hlsearch

" Move cursor to next search result
set incsearch

" Show substitution results as you are typing the regex out (Neovim only)
if has('nvim')
  set inccommand=nosplit
endif

" Automatically add g option with substitute
set gdefault

" Wildignore
set wildignore+=package-lock.json,yarn.lock,tags,Session.vim

" Don't care about accidental capitals
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev WQ wq

" Open help split vertically
" autocmd FileType help wincmd L

" Open up split windows and the more intuitive place
set splitright
set splitbelow

" Better display for messages
set cmdheight=2

" }}}


" TEMP due to neovim bug
nnoremap Y yy
