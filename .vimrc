set encoding=utf-8
" Vundle
" {{{

set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" PLUGINS GO HERE
" {
"
" Themes
Plugin 'morhetz/gruvbox'
Plugin 'chriskempson/base16-vim'

" CTags
Plugin 'ludovicchabant/vim-gutentags'

" NERDTree
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'Xuyuanp/nerdtree-git-plugin'

" File-related stuff
Plugin 'wincent/Command-T'
Plugin 'dkprice/vim-easygrep'

" Git
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" Airline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Space/indenting
Plugin 'tpope/vim-sleuth' " Detects space/tab sizes of current file
Plugin 'skopciewski/vim-better-whitespace'
" Plugin 'ntpeters/vim-better-whitespace' TODO Put this back after this pull request is merged https://github.com/ntpeters/vim-better-whitespace/pull/85
" TODO Use this plugin for whitespace https://github.com/thirtythreeforty/lessspace.vim

" Low level editing
Plugin 'dhruvasagar/vim-table-mode'
Plugin 'jiangmiao/auto-pairs'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-endwise'
Plugin 'scrooloose/nerdcommenter'
" Plugin 'justinmk/vim-sneak' " TODO remap to f/F

" Language packs
Plugin 'sheerun/vim-polyglot'

" Linting
Plugin 'w0rp/ale'

" Completion
Plugin 'ervandew/supertab'
Plugin 'Shougo/deoplete.nvim'
if !has('nvim')
  Plugin 'roxma/nvim-yarp'
  Plugin 'roxma/vim-hug-neovim-rpc'
endif
Plugin 'slashmili/alchemist.vim'

" Lilypond
Plugin 'gisraptor/vim-lilypond-integrator'

" PlantUML
Plugin 'aklt/plantuml-syntax'
Plugin 'weirongxu/plantuml-previewer.vim'

" Javascript
Plugin 'Galooshi/vim-import-js'

" Wintabs (must be after vim-airline)
Plugin 'zefei/vim-wintabs'
Plugin 'zefei/vim-wintabs-powerline'

" Miscellaneous
Plugin 'xolox/vim-misc'
Plugin 'tyru/open-browser.vim' " Required by tyru/open-browser.vim
Plugin 'arecarn/vim-crunch'
Plugin 'xolox/vim-session'

" }

call vundle#end()            " required
filetype plugin indent on    " required

" }}}



" Must be first stuff
" {{{

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



" Plugin Config
" {{{

" Command-T
nmap <silent> <Leader>f <Plug>(CommandT)
nmap <silent> <Leader>F <Plug>(CommandTMRU)
" TODO don't duplicate from gitignore
let g:CommandTWildIgnore = '
      \*/MacroSystem
      \,*/tags
      \,*/vendor
      \,*/plugins-src/ThorCordova-ios/Carthage
      \,*/Session.vim
      \'
let g:CommandTInputDebounce = 50
let g:CommandTAcceptSelectionSplitMap = '<C-b>'
let g:CommandTFileScanner = 'rg'
let g:CommandTMaxFiles = 30000

" EasyGrep
let g:EasyGrepJumpToMatch = 0
let g:EasyGrepRecursive = 1
let g:EasyGrepCommand = 'rg' " NOTE: Set to 'grep' if there are special characters
let g:EasyGrepReplaceWindowMode = 2

" Vim Airline Plugin
let g:airline_detect_modified=0
let g:airline_powerline_fonts=1
let g:airline_theme='base16'
" let g:airline_section_b = ''
let g:airline_section_x = ''
" let g:airline_section_y = ''
let g:airline_section_z = '%v'
let g:airline_detect_spell=0
let g:airline_detect_spelllang=0
let g:airline_detect_paste=1
let g:airline#extensions#hunks#enabled = 0
set laststatus=2 " Always show status line
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#tabs_label = ''
let g:airline#extensions#tabline#fnametruncate = 1
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#fnametruncate = 20

" Latex Live Preview
let g:livepreview_previewer = 'open -a Preview'

" Deoplete
let g:deoplete#enable_ignore_case = 1
let g:deoplete#auto_complete_start_length = 1
let g:deoplete#enable_at_startup = 0
au InsertEnter * call deoplete#enable() " Lazy load

" NERDTree
let g:nerdtree_tabs_open_on_gui_startup = 2
let g:nerdtree_tabs_open_on_console_startup = g:nerdtree_tabs_open_on_gui_startup
let NERDTreeShowLineNumbers=1 " enable line numbers
autocmd FileType nerdtree setlocal relativenumber
let NERDTreeShowHidden=1
nmap <leader>n :NERDTreeToggle<cr>
nmap <leader>N :NERDTreeFind<cr>

" Nerd Commenter
let g:NERDDefaultAlign = 'start'
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
let g:AutoPairsMapSpace = 0
let g:AutoPairsMultilineClose = 0

" Ale
let g:ale_completion_enabled = 1
let g:ale_set_signs = 1
let g:ale_change_sign_column_color = 1
let g:ale_sign_column_always = 0
let g:ale_completion_delay = 500
let g:ale_linters = {
      \ 'java': []
      \ }
" Turn linting errors into warnings
let g:ale_type_map = {
            \ 'tslint': {'ES': 'WS', 'E': 'W'},
            \ 'credo': {'ES': 'WS', 'E': 'W'}
            \ }
let g:ale_fixers = {
            \ 'typescript': ['tslint --fix'],
            \ 'javascript': ['eslint']
            \ }
let g:ale_typescript_tslint_use_global = 0
let g:ale_typescript_tsserver_use_global = 0
let g:ale_elixir_credo_use_global = 0
let g:ale_lint_on_enter = 0
nnoremap <leader>an :ALENextWrap<CR>
nnoremap <leader>ap :ALEPreviousWrap<CR>
nnoremap <leader>aj :ALEGoToDefinitionInTab<CR>
nnoremap <leader>af :ALEFix<CR>

" Import JS
nnoremap <leader>jj :ImportJSWord<CR>

" Better Whitespace
let g:better_whitespace_filetypes_blacklist = [
      \  'swift',
      \  'm',
      \  'h',
      \  'diff',
      \  'gitcommit',
      \  'unite',
      \  'qf',
      \  'help',
      \  'markdown'
      \]
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
autocmd FileType markdown
    \ set formatoptions-=q |
    \ set formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^\\s*\[-*+]\\s\\+

" Fugitive
nnoremap <Leader>gcm :w<CR>:Gcommit -v
nnoremap <Leader>gap :w<CR>:Git add -p<CR>i
nnoremap <Leader>gdf :w<CR>:Git diff<CR>
nnoremap <Leader>gs :w<CR>:Git status<CR>
nnoremap <Leader>gph :w<CR>:Gpush<Space>
nnoremap <Leader>gpl :w<CR>:Gpull<Space>

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
  nmap <Leader>qu <Plug>(wintabs_undo)
  nmap <Leader>qq <Plug>(wintabs_close)
  nmap <Leader>qm :WintabsMove<Space>

  " Override q,q!,wq to avoid accidentally closing all of the buffers in the
  " tab
  function! SaveAndCloseCurrentBuffer()
    :w
    call wintabs#close()
  endfunction
  call CommandCabbr('q', 'call wintabs#close()')
  call CommandCabbr('q!', 'call wintabs#close()')
  call CommandCabbr('wq', 'call SaveAndCloseCurrentBuffer()')
endif

" Vim Session
" Settings to get it to work like vim-obsession (save session in current directory)
let g:session_autoload = 'no'
let g:session_autosave = 'no'
let g:session_autosave_silent = 1
let g:session_lock_enabled = 0
let g:session_directory = './' 
let g:session_default_name = 'Session'
augroup vim_session_autosave
  au!
  au FocusLost,BufWritePost,VimLeave * silent! :SaveSession
augroup END


" Gutentags
" rg respects gitignore files. This command also filters out certain file types
" that we do not want tags for
let g:gutentags_file_list_command = "rg -l '.' | rg -v '(json|plist)$'"
let g:gutentags_define_advanced_commands = 1

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



" Key mappings
" {{{

" Clear highlighting
nnoremap <silent> <esc> <esc>:noh<cr>
inoremap <silent> <esc> <esc>:noh<cr>

" Splitting lines
nnoremap <C-j> i<CR><ESC>

" Align paragraph
nnoremap gqp gwip

" Whole file operatoins
nnoremap yaf mzggVGy`z
nnoremap daf mzggVGd`z
vnoremap af mzggoG$

" Replace (copy visual selection and paste in cmdline)
" (copy into z buffer because IntelliJ is buggy)
vnoremap <C-r> ygv"zy:%s/<C-r>z/<C-r>z

" Reload .vimrc
nnoremap <leader>sv :w<CR>:so $MYVIMRC<CR>

" Exporting documents
nnoremap <Leader>dm :w<CR>:!doc export '%'<CR>
nnoremap <Leader>dt :w<CR>:!pdflatex '%' && open %:r.pdf<CR>

" Smart indent when entering insert mode with i on empty lines
" https://stackoverflow.com/a/3003636/1726450
function! IndentWithI(default)
    if len(getline('.')) == 0
        return "\"_cc"
    else
        return a:default
    endif
endfunction
nnoremap <expr> i IndentWithI("i")
nnoremap <expr> a IndentWithI("a")

" 'Inspections'
" {{{
" Split list/params by comma (except trailing comma)
vnoremap <leader>i, mz:s/,\(\s*$\)\@\!/,\r/g<CR>=ap`z
" Put a new line at the start and end of the selection
vmap <leader>i<C-j> <ESC><Right><C-j>gvo<ESC><C-j>
" Split params by comma and start/end of selection (Doesnt work if nested method calls)
vmap <leader>i<CR> <leader>i<C-j>V<leader>i,
" Same as above, but selects automatically
nmap <leader>i<CR> v%<Right>o%%<Left><leader>i<CR>
" Split line into multiple lines by '.'
vnoremap <leader>i. :s/\./\r\./g<CR><ESC>mz=ap`z
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

" Auto format comments
nnoremap <leader>oa :set formatoptions+=a<CR>
nnoremap <leader>oA :set formatoptions-=a<CR>

" Select recently pasted text
nnoremap gp `[v`]

" Select current line except whitespace
nnoremap gV ^v$<Left>

" Copy current file to clipboard
nnoremap <Leader>% :call CopyToClipboard(expand('%'))<Left><Left><Left>

" Jump to definition - tjump in new tab
nnoremap <C-g><C-]> <C-w>s<C-w>Tg<C-]>

" File operations
nnoremap <C-q> :wa<CR>
nnoremap <C-c> :wqa

" Moving tabs
nnoremap <C-w>< :tabm-<CR>
nnoremap <C-w>> :tabm+<CR>

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
"
" Scrolling
set scrolloff=4
set sidescrolloff=4

" Text width
set textwidth=79

" Indenting defaults
" Defaults to 4 spaces for most filetypes
autocmd FileType typescript,javascript,jsx,tsx,css,html,ruby,elixir,kotlin,vim,plantuml
      \ setlocal expandtab tabstop=2 shiftwidth=2
" setglobal seems to not override sleuth when reloading vimrc
setglobal expandtab
setglobal tabstop=4
setglobal shiftwidth=4

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
au FocusLost * silent! :wa

" Auto reload
set autoread
au FocusGained,BufEnter * :silent! checktime " Taken from https://stackoverflow.com/a/2329094/1726450

" Tags
set tags=./tags;

" Don't wrap long lines onto the next line on the screen
set nowrap

" Clear highlighting and StripWhitespace
" autocmd BufEnter * if index(g:better_whitespace_filetypes_blacklist, &ft) < 0
"       \ |   exec 'EnableStripWhitespaceOnSave'
"       \ | else
"       \ |   exec 'DisableStripWhitespaceOnSave'
"       \ | endif

" No double space after running `gq` on a line with a '.' at the end
set nojoinspaces

" Get bg color to work in tmux
set t_ut=

" Colors in vimr
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

" TODO Use a plugin and instead of making the function myself
function! g:CopyToClipboard(string)
  silent exec "!echo " . a:string . " | pbcopy"
  echom "Copied: '" . a:string . "'"
endfunction

" Split shortcut (to be compatible with Command-T)
nnoremap <C-w>b <C-w>s

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

" Case (and smart case in command mode)
set ignorecase
augroup dynamic_smartcase
  autocmd!
  autocmd CmdLineEnter : set nosmartcase
  autocmd CmdLineLeave : set smartcase
augroup END

" Don't wrap in the middle of a word
set linebreak

" Highlight search results
set hlsearch

" Scroll speed customisation
" map <ScrollWheelUp> <C-Y>
" map <ScrollWheelDown> <C-E>

" Show substitution results as you are typing the regex out (Neovim only)
set inccommand=nosplit

" Wildignore
set wildignore+=package-lock.json,yarn.lock,tags,Session.vim

" }}}
