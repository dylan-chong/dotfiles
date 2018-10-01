" Must be first stuff
" {{{

set encoding=utf-8

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

" }}}



" Vim-Plug
" {{{

" Automatically install vim-plug if not installed
" (https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation)
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" PLUGINS GO HERE
" {

" Themes
Plug 'chriskempson/base16-vim'

" CTags
Plug 'ludovicchabant/vim-gutentags'

" NERDTree
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Xuyuanp/nerdtree-git-plugin'

" File-related stuff
Plug 'nhuizing/vim-easygrep', {
      \ 'branch': 'feature/bugfix_git_grep'
      \ }
Plug 'tpope/vim-eunuch'

" FZF
set rtp+=/usr/local/opt/fzf
Plug 'junegunn/fzf.vim'
Plug 'tweekmonster/fzf-filemru'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Space/indenting
Plug 'tpope/vim-sleuth' " Detects space/tab sizes of current file
Plug 'tweekmonster/wstrip.vim' " Strip whitespace from lines changed
Plug 'ntpeters/vim-better-whitespace' " Used only for :StripWhitespace

" Low level editing
Plug 'dhruvasagar/vim-table-mode'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'scrooloose/nerdcommenter'
Plug 'godlygeek/tabular' " Space out code into tables

" Language packs
Plug 'sheerun/vim-polyglot'

" Linting
Plug 'w0rp/ale'

" LSP
Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': 'bash install.sh',
      \ }

" Completion
Plug 'ervandew/supertab'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'slashmili/alchemist.vim' " Elixir

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

" JSON
Plug 'tpope/vim-jdaddy' " JSON formatting

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
colorscheme base16-materia

" Highlight line/column
" set cursorline

" End column
hi ColorColumn ctermbg=52
" Highlight only if there is a character on the column
cal matchadd('ColorColumn', '\%81v', 100)

" }}}



" Plugin Config
" {{{

" EasyGrep
let g:EasyGrepJumpToMatch = 0
let g:EasyGrepRecursive = 1
let g:EasyGrepCommand = 'git'
let g:EasyGrepReplaceWindowMode = 2

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
let g:deoplete#enable_at_startup = 0
call deoplete#custom#option('num_processes', 1) " Temporary workaround https://github.com/Shougo/deoplete.nvim/issues/761#issuecomment-389701983
au InsertEnter * call deoplete#enable() " Lazy load

" NERDTree
let g:nerdtree_tabs_open_on_gui_startup = 2
let g:nerdtree_tabs_open_on_console_startup = g:nerdtree_tabs_open_on_gui_startup
let NERDTreeShowLineNumbers=1 " enable line numbers
autocmd FileType nerdtree setlocal relativenumber
let NERDTreeShowHidden=1
let g:NERDTreeWinSize=45
nmap <leader>n :NERDTreeMirrorToggle<cr>
nmap <leader>N :NERDTreeFind<cr>

" Nerd Commenter
" let g:NERDDefaultAlign = 'start'
let g:NERDRemoveExtraSpaces = 0
let g:NERDTrimTrailingWhitespace = 1
let g:NERDSpaceDelims = 1
nmap gc <leader>c<space>
vmap gc <leader>c<space>

" Supertab
let g:SuperTabDefaultCompletionType = "<c-n>"

" Alchemist
let g:alchemist#elixir_erlang_src = '~/.elixir-completion/'

" AutoPairs
let g:AutoPairsMapSpace = 1
let g:AutoPairsMultilineClose = 0

" Ale
let g:ale_completion_enabled = 1
let g:ale_set_signs = 1
let g:ale_change_sign_column_color = 0
let g:ale_sign_column_always = 0
let g:ale_completion_delay = 500
let g:ale_linters = {
      \ 'java': [],
      \ 'typescript': ['tslint'],
      \ }
" Turn linting errors into warnings
let g:ale_type_map = {
      \ 'tslint': {'ES': 'WS', 'E': 'W'},
      \ 'credo': {'ES': 'WS', 'E': 'W'}
      \ }
let g:ale_fixers = {
      \ 'typescript': ['tslint --fix'],
      \ 'javascript': ['eslint'],
      \ 'python': ['autopep8']
      \ }
let g:ale_typescript_tslint_use_global = 0
let g:ale_elixir_credo_use_global = 0
let g:ale_lint_on_enter = 0
nnoremap <leader>an :ALENextWrap<CR>
nnoremap <leader>ap :ALEPreviousWrap<CR>
nnoremap <leader>ad :ALEGoToDefinition<CR>
nnoremap <leader>af :ALEFix<CR>

" Import JS
nnoremap <leader>jj :ImportJSWord<CR>
nnoremap <leader>jf :ImportJSFix<CR>

" Better Whitespace
let g:better_whitespace_enabled = 0

" Git Gutter
set updatetime=300
nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk

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
" Hack to fix bulet point problem
" autocmd FileType markdown
"     \ set formatoptions-=q |
"     \ set formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^\\s*\[-*+]\\s\\+
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0

" Fugitive
nnoremap <Leader>gcm :wa<CR>:Gcommit -v
nnoremap <Leader>gap :wa<CR>:Git add -p<CR>i
nnoremap <Leader>gdf :wa<CR>:Git diff<CR>i
nnoremap <Leader>gs :wa<CR>:Git status<CR>i
nnoremap <Leader>gph :wa<CR>:Gpush<Space>
nnoremap <Leader>gpl :wa<CR>:Gpull<Space>
nnoremap <Leader>gb :wa<CR>:Gblame<CR>

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

  " Override q,q!,wq to avoid accidentally closing all of the buffers in the
  " tab
  function! SaveAndCloseCurrentBuffer()
    :up
    call wintabs#close()
  endfunction
  call CommandCabbr('q', 'call wintabs#close()')
  call CommandCabbr('q!', 'call wintabs#close()')
  call CommandCabbr('wq', 'call SaveAndCloseCurrentBuffer()')
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
" Jump to existing buffer when opening file with FZF
set switchbuf=usetab

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

" Gutentags
" rg respects gitignore files. This command also filters out certain file types
" that we do not want tags for
let g:gutentags_file_list_command = "rg -l '.' | rg -v '(json|plist)$'"
let g:gutentags_define_advanced_commands = 1

" FZF
let g:fzf_history_dir = '~/.local/share/fzf-history'
" An action can be a reference to a function that processes selected lines
function! s:fzf_build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction
function! s:fzf_open_buffers(lines)
  echom "Hello"
  echom string(a:lines)
  for file_name in a:lines
    execute 'e ' . fnameescape(file_name)
  endfor
endfunction
let g:fzf_action = {
      \ 'ctrl-q': function('s:fzf_build_quickfix_list'),
      \ 'ctrl-b': function('s:fzf_open_buffers'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit',
      \ }
nnoremap <silent> <Leader>f :call fzf#vim#files('', fzf#vim#with_preview('right'))<CR>
nnoremap <silent> <Leader>F :FilesMru --tiebreak=end<cr>
" Search for files similar to the current one (ignoring the current file
" extensions in filenames like feed.component.spec.ts and also '-test' in
" 'game-test.js'). For example, you want to switch between html, css,
" javascript and files - or even spec and implementation in different
" directories. Note: This may pick up irrelevant files, but hopefully they
" should not appear at the bottom of the search results (where the most
" relevant ones are).
function! s:fzf_open_similar_files()
  " Get rid of extensions
  let base_file_name = substitute(expand('%:t'), '\v([^\.]+)%(\..*|$)', '\1', '')
  " Get rid of -test and such
  let base_file_name = substitute(base_file_name, '\v\c%(-|_)%(test|spec)', '', '')

  let is_in_subdirectory = expand('%') =~ '/'
  if is_in_subdirectory
    " Include directory structure in search to improve the accuracy of search
    " results. Very useful in situations where you have files like
    " app/controllers/api/v4/foo_controller.rb with v4, v3, etc
    let simplified_directory = substitute(
          \   expand('%:h'),
          \   '\v(app|src|spec|test|__test__|__tests__)',
          \   '',
          \   'g'
          \ )
    let simplified_directory = substitute(simplified_directory, '//', '/', 'g')
    let simplified_directory = substitute(simplified_directory, '^/', '', 'g')
    " simplify_directory may not exactly match the actual directory of the file
    " you are looking for, but that is okay because fzf does a fuzzy search
    let main_search_term = simplified_directory . '/' . base_file_name
  else
    let main_search_term = "'" . base_file_name
  endif

  let query = '!^' . expand('%') . "$\\ " . main_search_term
  let command = ':FZF --tiebreak=end,length -q ' . query
  execute command
endfunction
nnoremap <silent> <Leader><C-f> :call <SID>fzf_open_similar_files()<CR>
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
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   "rg --column --line-number --no-heading --color=always --smart-case -g '!.git' --hidden ".shellescape(<q-args>), 1,
      \   fzf#vim#with_preview('right:35%'),
      \   <bang>0)
cnoreabbrev rg Rg

" Codi
let g:codi#rightalign = 0
let g:codi#width = 70

" WStrip
" Globally enabled for all filetypes
let g:wstrip_auto = 1

" LanguageClient neovim
set hidden " Required for operations modifying multiple buffers like rename.
let g:LanguageClient_serverCommands = {
      \ 'typescript': ['typescript-language-server', '--stdio'],
      \ }
let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
let g:LanguageClient_loggingLevel = 'INFO'
let g:LanguageClient_serverStderr = '/tmp/LanguageServer.log'
let g:LanguageClient_windowLogMessageLevel = 'Error'
let g:LanguageClient_diagnosticsList = 'Disabled'
nnoremap <Leader>ll :call LanguageClient_contextMenu()<CR>
nnoremap <Leader>ld :call LanguageClient#textDocument_definition()<CR>
nnoremap <Leader>la :call LanguageClient#textDocument_codeAction()<CR>
nnoremap <Leader>lr <C-w>s<C-w>T:call LanguageClient#textDocument_rename()<CR>

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

" Wrap paragraph
nnoremap gqp gwip

" Save one keystroke when aligning code
nnoremap =p mz=ap`z

" Whole file operatoins
nnoremap yaf mzggVGy`z
nnoremap daf mzggVGd`z
vnoremap af mzggoG$

" Replace (a (local) variable name)
" Part 1: Yank current selection (for example a variableName)
vnoremap <C-p> "xyV
" Part 1.1: (Optional variant of part 1 - select current word)
nnoremap <C-p> viw"xyV
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
nnoremap <Leader>dm :w<CR>:!doc export '%'<CR>
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
" Split line into multiple lines by '.'
vnoremap <leader>i. :s/\./\r\.<CR><ESC>mz=ap`z
" }}}

" Don't deselect text on indent
vnoremap < <gv
vnoremap > >gv

" Duplicate buffer in new tab
nnoremap <C-w>d <C-w>s<C-w>T
nmap <C-w>D <C-w>d:tabm-<CR>

" Switch to last tab
let g:lasttab = 1
nnoremap <Leader>gt :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Toggling options
nnoremap <leader>oa :set formatoptions+=a<CR>
nnoremap <leader>oA :set formatoptions-=a<CR>
nnoremap <leader>ow :set nowrap<CR>
nnoremap <leader>oW :set wrap<CR>
nnoremap <leader>oF :set filetype=
nnoremap <leader>ofp :set filetype=python<CR>
nnoremap <leader>ofj :set filetype=javascript<CR>
nnoremap <leader>ofe :set filetype=elixir<CR>
nnoremap <leader>ofr :set filetype=ruby<CR>
nnoremap <leader>ofm :set filetype=markdown<CR>

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
nnoremap <C-q> :wa<CR>
nnoremap <C-c> :wqa

" Change case of first letter of current word in insert mode
inoremap <C-b>b <Esc>mzviwo<Esc>~`za
inoremap <C-b>B <Esc>mzviWo<Esc>~`za

" Change case of current word in insert mode
inoremap <C-b>u <Esc>mzguiw`za
inoremap <C-b>U <Esc>mzgUiw`za

" Delete whole word
inoremap <C-b><C-w> <Esc>ciW

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
nnoremap <Leader>Tc :tabclose<CR>
nnoremap <Leader>To :tabonly<CR>
nnoremap <Leader>T< :tabm<Space>-
nnoremap <Leader>T> :tabm<Space>+

" Goto start of line in command mode (make going to the end and start of lines
" consistent with terminal emacs shortcuts)
cnoremap <C-a> <C-b>

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
" TODO this has no effect in neovim because of a bug
" https://github.com/neovim/neovim/issues/6211
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

" Text width
set textwidth=79

" Don't wrap on typing
set formatoptions-=t

" Indenting defaults
" Defaults to 4 spaces for most filetypes
if get(g:, '_has_set_default_indent_settings', 0) == 0
  autocmd FileType typescript,javascript,jsx,tsx,scss,css,html,json,ruby,elixir,kotlin,vim,tmux,plantuml
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
au BufEnter * set relativenumber
au BufEnter * set number

" Somehow maybe gets the Mac clipboard to work
set clipboard=unnamed

" Backspace fix
set backspace=2

" Odd filetypes/extensions
au BufRead,BufNewFile *.js.applescript set filetype=javascript

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
autocmd FileType markdown,text,bib,latex,plaintex setlocal spell

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

" }}}
