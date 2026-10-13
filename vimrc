" ==============================================================================
"                       MODERN VIM CONFIGURATION (~/.vimrc)
" ==============================================================================
" Crafted for high productivity, modern aesthetics, and interactive guidance.
"
" Leader key: <Space>
" Help / Cheatsheet: Press <Space>? or run :Guide
" ==============================================================================

" ------------------------------------------------------------------------------
" 1. GENERAL & INITIALIZATION
" ------------------------------------------------------------------------------
set nocompatible              " Be iMproved, required for modern vim features
filetype off                  " Required before plugin initialization

let mapleader = "\<Space>"    " Space is the most ergonomic leader key
let maplocalleader = ","

" Auto-bootstrap vim-plug if not installed
let s:plug_path = expand('~/.vim/autoload/plug.vim')
if empty(glob(s:plug_path))
  silent execute '!curl -fLo ' . s:plug_path . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ------------------------------------------------------------------------------
" 2. PLUGIN SPECIFICATION (vim-plug)
" ------------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')

" Appearance & Aesthetics
Plug 'joshdick/onedark.vim'            " Modern Atom One Dark theme
Plug 'morhetz/gruvbox'                 " Classic retro groove theme
Plug 'itchyny/lightline.vim'           " Fast, lightweight statusline & tabline
Plug 'ryanoasis/vim-devicons'          " File icons for trees & statusline

" Navigation & Fuzzy Finder (leveraging installed fzf & ripgrep)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'                " High-performance fuzzy search tools

" File Management
Plug 'preservim/nerdtree'              " Modern file tree sidebar
Plug 'Xuyuanp/nerdtree-git-plugin'     " Show git status indicators in NERDTree

" Git Integration
Plug 'tpope/vim-fugitive'              " Definitive Git wrapper (:Git, :Gblame, etc.)
Plug 'airblade/vim-gitgutter'          " Real-time git diff signs in gutter & hunk navigation

" Interactive Guidance & Helpers
Plug 'liuchengxu/vim-which-key'        " Interactive popup displaying keybindings on leader press
Plug 'mbbill/undotree'                 " Visual undo history tree

" Editing Power Tools & Motions
Plug 'tpope/vim-commentary'            " Quick commenting: gcc (line), gc (motion/visual)
Plug 'tpope/vim-surround'              " Quotes/brackets helper: ysiw", cs"', ds"
Plug 'tpope/vim-repeat'                " Repeat plugin actions with '.'
Plug 'jiangmiao/auto-pairs'            " Auto-close matching brackets and quotes
Plug 'mg979/vim-visual-multi'          " Multiple cursors (Ctrl+N)
Plug 'justinmk/vim-sneak'              " Lightning-fast 2-character motion (s{char}{char})
Plug 'romainl/vim-cool'                " Auto-clear search highlights upon cursor movement
Plug 'psliwka/vim-smoothie'            " Smooth animated scrolling (Ctrl-D, Ctrl-U)

" Syntax, Indentation & Visual Structure
Plug 'sheerun/vim-polyglot'            " High-quality syntax & indentation for 100+ languages
Plug 'Yggdroot/indentLine'             " Indentation guide bars (│)

" Session & State Management
Plug 'tpope/vim-obsession'             " Continuous automatic session tracking (:Obsession)

" Code Intelligence & LSP (Pure Vimscript, fast & lightweight)
Plug 'prabirshrestha/vim-lsp'          " Async Language Server Protocol client
Plug 'mattn/vim-lsp-settings'          " Automated server installer (:LspInstallServer)
Plug 'prabirshrestha/asyncomplete.vim' " Async autocomplete popup
Plug 'prabirshrestha/asyncomplete-lsp.vim' " LSP autocomplete bridge
Plug 'prabirshrestha/asyncomplete-buffer.vim' " Buffer word completion source
Plug 'prabirshrestha/asyncomplete-file.vim'   " File path completion source

" AI Assistance & Autocomplete
Plug 'github/copilot.vim'              " Official GitHub Copilot inline AI completions

call plug#end()

filetype plugin indent on      " Enable file type detection, plugins, and indentation
syntax on                      " Syntax highlighting

" ------------------------------------------------------------------------------
" 3. MODERN UI & DISPLAY SETTINGS
" ------------------------------------------------------------------------------
if (has("termguicolors"))
  " Enable 24-bit RGB true color in modern terminals
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set background=dark
try
  colorscheme onedark
catch
  try
    colorscheme gruvbox
  catch
    colorscheme desert
  endtry
endtry

" Hybrid line numbers: shows absolute number on current line, relative elsewhere
set number
set relativenumber

" Automatically toggle relative numbers in Insert mode or when losing focus
augroup NumberToggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

set cursorline                 " Highlight the current screen line
set signcolumn=yes             " Always show sign column to prevent text shifting
set scrolloff=8                " Keep 8 lines of context above/below cursor
set sidescrolloff=8            " Keep 8 columns of context to the left/right
set wrap                       " Soft-wrap long lines
set linebreak                  " Break long lines at sensible words rather than middle of word
set showcmd                    " Show partial command keys in bottom bar
set showmode                   " Display current mode (-- INSERT --, etc.)
set laststatus=2               " Always display the statusline
set ruler                      " Show cursor position (row, col)
set cmdheight=1                " Command bar height
set list                       " Show subtle trailing whitespace characters
set listchars=tab:→\ ,trail:•,extends:›,precedes:‹,nbsp:␣

" Modern cursor styling: beam in Insert, block in Normal, underline in Replace
if exists('$TERM')
  let &t_SI = "\<Esc>[6 q"     " Solid line / beam
  let &t_SR = "\<Esc>[4 q"     " Underline
  let &t_EI = "\<Esc>[2 q"     " Solid block
endif

" Visual Buffer Tab Bar (Shows all open files across top of screen)
set showtabline=2              " Always show top tabline with open files
function! BufferTabLine() abort
  let l:s = ''
  let l:cur = bufnr('%')
  for b in range(1, bufnr('$'))
    if buflisted(b)
      let l:name = bufname(b)
      let l:name = empty(l:name) ? '[No Name]' : fnamemodify(l:name, ':t')
      let l:mod = getbufvar(b, '&modified') ? ' ●' : ''
      let l:s .= (b == l:cur ? '%#TabLineSel#' : '%#TabLine#')
      let l:s .= ' ' . b . ':' . l:name . l:mod . ' '
    endif
  endfor
  let l:s .= '%#TabLineFill#%='
  return l:s
endfunction
set tabline=%!BufferTabLine()

" ------------------------------------------------------------------------------
" 4. EDITING, INDENTATION & BEHAVIOR
" ------------------------------------------------------------------------------
set encoding=utf-8             " Default string encoding
set fileencoding=utf-8
set backspace=indent,eol,start " Standard backspacing over everything in Insert mode
set tabstop=4                  " Number of visual spaces per tab
set softtabstop=4              " Number of spaces in tab when editing
set shiftwidth=4               " Number of spaces to use for (auto)indent
set expandtab                  " Turn tabs into spaces
set smartindent                " Smart auto-indenting for new lines
set autoindent

" Better searching
set ignorecase                 " Case-insensitive search by default
set smartcase                  " Switch to case-sensitive if uppercase letter is typed
set incsearch                  " Search incrementally as you type
set hlsearch                   " Highlight matching search results

" Interactive Command-Line Popup Menu (suggestions appear when typing : commands!)
set wildmenu                   " Enhanced command-line completion
set wildmode=longest:full,full
if has('patch-8.2.0001') || exists('&wildoptions')
  set wildoptions=pum          " Display command suggestions in a clean popup dropdown
endif

" Better completion behavior in Insert mode
set completeopt=menu,menuone,noselect,preview

" Natural window splitting
set splitbelow                 " Open new horizontal splits below
set splitright                 " Open new vertical splits to the right

" Performance and responsiveness
set updatetime=300             " Faster gitgutter updates and hover popups (default 4000ms)
set timeoutlen=300             " Snappy Which-Key popup menu on <Space> press
set ttimeoutlen=50

" System clipboard integration (macOS pbcopy/pbpaste seamless)
if has('clipboard')
  set clipboard=unnamed,unnamedplus
endif

" Mouse support for scrolling, selecting, and clicking
if has('mouse')
  set mouse=a
  " Auto-copy mouse visual selection to macOS clipboard on release
  vnoremap <silent> <LeftRelease> "*y
endif

" Seamless Clipboard shortcuts: Ctrl+v to paste, Ctrl+c to copy
nnoremap <C-v> "+p
vnoremap <C-v> "+p
inoremap <C-v> <C-r>+
cnoremap <C-v> <C-r>+
vnoremap <C-c> "+y

" Persistent Undo (saves undo history across file closes!)
if has('persistent_undo')
  let s:undodir = expand('~/.vim/undodir')
  if !isdirectory(s:undodir)
    call mkdir(s:undodir, 'p')
  endif
  let &undodir = s:undodir
  set undofile
endif

" Sensible backup, swap, and state storage
set nobackup
set nowritebackup
set noswapfile
set viminfo='100,<50,s10,h

" Restore cursor to last recorded position upon opening a file
augroup RestoreCursor
  autocmd!
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") && &filetype !~# 'commit' |
    \   execute "normal! g`\"" |
    \ endif
augroup END

" Trim trailing whitespace on save (excluding markdown and git diffs)
function! s:TrimWhitespace() abort
  if &filetype =~# 'markdown\|diff'
    return
  endif
  let l:save_cursor = getpos(".")
  keeppatterns %s/\s\+$//e
  call setpos('.', l:save_cursor)
endfunction
command! -bar TrimWhitespace call <SID>TrimWhitespace()

augroup CleanWhitespace
  autocmd!
  autocmd BufWritePre * call s:TrimWhitespace()
augroup END

" Smart File:Line:Column Opener (e.g. `vim file.py:42` or `nvim file.py:42:10`)
function! s:OpenFileWithLine() abort
  let l:file = expand('%')
  if empty(l:file) || filereadable(l:file)
    return
  endif
  let l:parts = matchlist(l:file, '^\(.\+\):\(\d\+\)\%(:\(\d\+\)\)\?$')
  if !empty(l:parts) && filereadable(l:parts[1])
    let l:target_file = l:parts[1]
    let l:target_line = l:parts[2]
    let l:target_col  = empty(l:parts[3]) ? 1 : l:parts[3]
    let l:old_buf = bufnr('%')
    execute 'edit ' . fnameescape(l:target_file)
    execute l:target_line
    execute 'normal! ' . l:target_col . '|'
    execute 'bdelete! ' . l:old_buf
  endif
endfunction

augroup FileWithLine
  autocmd!
  autocmd BufNewFile *:* call s:OpenFileWithLine()
augroup END

" ------------------------------------------------------------------------------
" 5. PLUGIN CONFIGURATIONS
" ------------------------------------------------------------------------------

" IndentLine (visual indent guide bars)
let g:indentLine_char = '│'
let g:indentLine_fileTypeExclude = ['text', 'help', 'nerdtree', 'fzf', 'terminal', 'help']
let g:indentLine_bufNameExclude = ['_.*', 'NERD_tree.*']

" Vim-Sneak (2-character fast jump motion)
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1

" Vim-Smoothie (buttery smooth scrolling)
let g:smoothie_enabled = 1

" Lightline statusbar with permanent navigation & command hints
let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'hint' ] ]
      \ },
      \ 'component': {
      \   'hint': '⌨ <Space>:Menu  u:Undo  ]d:Err  <C-o>:Back  :q:Quit  <F1>:Help'
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" NERDTree File Explorer
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = ['^\.git$', '^\.DS_Store$', '^node_modules$', '^__pycache__$']
let g:NERDTreeWinSize = 32

" Automatically open NERDTree when opening a folder (e.g. `vim .` or `v ~/project`)
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
      \ execute 'NERDTree' argv()[0] |
      \ wincmd p |
      \ enew |
      \ execute 'cd ' . argv()[0] |
      \ endif

" Close vim if the only window left open is NERDTree
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" GitHub Copilot settings
let g:copilot_no_tab_map = v:false

" GitGutter
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '▎'
let g:gitgutter_sign_removed = '▏'
let g:gitgutter_sign_removed_first_line = '▔'
let g:gitgutter_sign_modified_removed = '▎'

" FZF settings
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.7 } }
let $FZF_DEFAULT_OPTS = '--reverse --border --inline-info'

" Prevent Esc from dropping into non-modifiable Terminal-Normal mode inside FZF
augroup FZFKeybindings
  autocmd!
  autocmd FileType fzf tnoremap <buffer> <nowait> <silent> <Esc> <c-c>
  autocmd FileType fzf tnoremap <buffer> <nowait> <silent> <C-c> <c-c>
  autocmd FileType fzf nnoremap <buffer> <silent> <Esc> :close<CR>
  autocmd FileType fzf nnoremap <buffer> <silent> q :close<CR>
augroup END

" Visual Multi (Multiple cursors)
let g:VM_default_mappings = 1
let g:VM_maps = {}
let g:VM_maps['Find Under'] = '<C-n>'

" Undotree
let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1

" Auto-Pairs configuration
let g:AutoPairsShortcutToggle = ''

" Vim-LSP and Asyncomplete settings
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_highlights_enabled = 1
let g:lsp_diagnostics_signs_enabled = 1
let g:asyncomplete_auto_popup = 1

" Register Asyncomplete Buffer & File sources (Universal autocomplete in all files)
augroup AsyncompleteCustom
  autocmd!
  autocmd User asyncomplete_setup if exists('*asyncomplete#sources#buffer#get_source_config') | call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_config({
        \ 'name': 'buffer',
        \ 'allowlist': ['*'],
        \ 'completor': function('asyncomplete#sources#buffer#completor'),
        \ 'config': {
        \    'max_buffer_size': 5000000,
        \ },
        \ })) | endif
  autocmd User asyncomplete_setup if exists('*asyncomplete#sources#file#get_source_config') | call asyncomplete#register_source(asyncomplete#sources#file#get_source_config({
        \ 'name': 'file',
        \ 'allowlist': ['*'],
        \ 'completor': function('asyncomplete#sources#file#completor'),
        \ })) | endif
augroup END

" ------------------------------------------------------------------------------
" 6. WHICH-KEY & INTERACTIVE GUIDANCE
" ------------------------------------------------------------------------------
let g:which_key_use_floating_win = 1
let g:which_key_max_size = 0
let g:which_key_exit = ["\<Esc>", "\<C-c>", "q"]

" Define leader mappings dictionary for vim-which-key
let g:which_key_map = {}

" Top-level actions
let g:which_key_map['?'] = [ ':Guide',            'Open cheatsheet guide' ]
let g:which_key_map['p'] = [ ':Commands',         'Command Palette (Search all commands)' ]
let g:which_key_map['<Space>'] = [ ':Commands',   'Command Palette (Search all commands)' ]
let g:which_key_map[':'] = [ ':Commands',         'Command Palette' ]
let g:which_key_map['w'] = [ ':w',                'Save file' ]
let g:which_key_map['/'] = [ ':nohlsearch',       'Clear search highlight' ]
let g:which_key_map['t'] = [ ':ToggleTerminal',   'Toggle terminal drawer' ]
let g:which_key_map['Q'] = [ ':ForceQuit',        'Force quit all (:qa!)' ]
let g:which_key_map['z'] = [ ':ToggleZoom',        'Toggle zoom active window (maximize/restore)' ]

" Undo, History & Backpropagation (Revert to old state)
let g:which_key_map.u = {
      \ 'name': '+undo/revert/backprop',
      \ 'u': [':Undo',             'Undo last edit (u)'],
      \ 'r': [':Redo',             'Redo last edit (<C-r>)'],
      \ 't': [':UndotreeToggle',   'Visual Undo Tree (Time travel)'],
      \ 'e': [':RevertFile',       'Revert file to disk (discard unsaved edits)'],
      \ 'o': [':JumpBack',         'Jump back to older position / file (<C-o>)'],
      \ 'i': [':JumpForward',      'Jump forward to newer position (<C-i>)'],
      \ }

" Quit, Close & Exit (Leave window / abort)
let g:which_key_map.q = {
      \ 'name': '+quit/close/exit',
      \ 'q': [':q',                'Quit current window (:q)'],
      \ 'w': [':QuitWindow',       'Close current split / window (:close)'],
      \ 'f': [':q!',               'Force quit window - discard edits (:q!)'],
      \ 'a': [':qa',               'Quit all windows (:qa)'],
      \ 'A': [':ForceQuit',        'Force quit all - discard all edits (:qa!)'],
      \ 'b': [':bdelete!',         'Force delete / close current buffer (:bd!)'],
      \ 'o': [':CloseAllOthers',   'Close all other splits (:only)'],
      \ }

" File & Explorer
let g:which_key_map.e = {
      \ 'name': '+explorer',
      \ 'e': [':NERDTreeToggle',       'Toggle file tree'],
      \ 'f': [':NERDTreeFind',         'Find current file in tree'],
      \ 'r': [':NERDTreeRefreshRoot',  'Refresh tree'],
      \ 'p': [':CdProject',            'Jump to project / folder (zoxide)'],
      \ }

" Fuzzy Finder (fzf)
let g:which_key_map.f = {
      \ 'name': '+find/fuzzy',
      \ 'f': [':Files',       'Search files in project'],
      \ 'g': [':Rg',          'Search text in project (Ripgrep)'],
      \ 'w': [':RgWord',      'Search word under cursor in project'],
      \ 'b': [':Buffers',     'Search open buffers'],
      \ 'l': [':BLines',      'Search lines in current buffer'],
      \ 'h': [':History',     'Search file history'],
      \ 'c': [':Commands',    'Search Vim commands'],
      \ 'm': [':Marks',       'Search marks'],
      \ }

" Git Tools
let g:which_key_map.g = {
      \ 'name': '+git',
      \ 's': [':Git',                  'Git status dashboard'],
      \ 'b': [':Git blame',            'Git blame'],
      \ 'd': [':Gdiffsplit',           'Git side-by-side diff'],
      \ 'D': [':DiffWith',             'Side-by-side vertical diff with file'],
      \ 'p': [':GitGutterPreviewHunk', 'Preview git hunk at cursor'],
      \ 'u': [':GitGutterUndoHunk',    'Undo git hunk at cursor'],
      \ 'a': [':GitGutterStageHunk',   'Stage git hunk at cursor'],
      \ 'w': [':RgWord',               'Search word under cursor in project (Rg)'],
      \ }

" Buffers
let g:which_key_map.b = {
      \ 'name': '+buffer',
      \ 'd': [':bdelete',     'Delete/close current buffer'],
      \ 'n': [':bnext',       'Next buffer'],
      \ 'p': [':bprevious',   'Previous buffer'],
      \ 'l': [':Buffers',     'List/find buffers'],
      \ 's': [':Scratch',     'Open disposable scratchpad buffer'],
      \ 'j': [':DailyNote',   'Open today''s Dev Journal (notes/YYYY-MM-DD.md)'],
      \ }

" Windows
let g:which_key_map.v = {
      \ 'name': '+windows',
      \ 's': [':split',       'Horizontal split'],
      \ 'v': [':vsplit',      'Vertical split'],
      \ 'c': [':close',       'Close window'],
      \ 'o': [':only',        'Close all other windows'],
      \ 'z': [':ToggleZoom',  'Toggle zoom split (maximize/restore)'],
      \ '=': ['<C-w>=',       'Equalize window sizes'],
      \ }

" Code & LSP
let g:which_key_map.c = {
      \ 'name': '+code/lsp',
      \ 'd': [':LspDefinition',         'Go to definition'],
      \ 'r': [':LspReferences',         'Find references'],
      \ 'e': [':LspDiagnostic',         'Show diagnostic error / warning message'],
      \ 'o': [':BTags',                 'Code outline (symbols / functions in file)'],
      \ 'b': [':Bookmarks',             'Jump to bookmarked project (~/.bookmarks)'],
      \ 'p': [':Snippets',              'Insert code snippet from ~/.snippets'],
      \ 'h': [':LspHover',              'Show hover documentation'],
      \ 'n': [':LspRename',             'Rename symbol'],
      \ 'a': [':LspCodeAction',         'Code actions'],
      \ 'f': [':Format',                'Format code / auto-indent'],
      \ 'i': [':LspInstallServer',      'Install language server for filetype'],
      \ 's': [':LspStatus',             'LSP server status'],
      \ }

" Copy / Yank Paths
let g:which_key_map.y = {
      \ 'name': '+yank/path',
      \ 'p': [':CopyFullPath', 'Copy full absolute file path'],
      \ 'r': [':CopyRelPath',  'Copy relative file path'],
      \ 'n': [':CopyFileName', 'Copy file name'],
      \ }

" Quickfix & Lists
let g:which_key_map.x = {
      \ 'name': '+quickfix',
      \ 'q': [':ToggleQuickfix', 'Toggle Quickfix window'],
      \ 'n': [':cnext',          'Jump to next quickfix error'],
      \ 'p': [':cprev',          'Jump to previous quickfix error'],
      \ }

" Run & Refactor
let g:which_key_map.r = {
      \ 'name': '+run/refactor',
      \ 'f': [':RunFile',     'Run current file in terminal drawer'],
      \ 'l': [':RunLast',     'Re-run last command in terminal drawer'],
      \ 't': [':RunTask',     'Interactive project task runner (frun)'],
      \ 'w': [':ReplaceWord', 'Search & replace word under cursor'],
      \ }

" Settings, Sessions & System
let g:which_key_map.s = {
      \ 'name': '+settings/session',
      \ 'v': [':ReloadConfig',          'Reload .vimrc configuration'],
      \ 's': [':SaveSession',           'Save workspace session'],
      \ 'r': [':RestoreSession',        'Restore workspace session'],
      \ 'o': [':Obsession',             'Toggle continuous session tracker'],
      \ 'n': [':Snippets',              'Insert code snippet from ~/.snippets'],
      \ 'w': [':TrimWhitespace',        'Strip trailing whitespace'],
      \ 'h': [':VimHealth',             'Check Vim status & health'],
      \ }

" AI Agents & Harnesses
let g:which_key_map.a = {
      \ 'name': '+ai-agent',
      \ 'g': [':Agy',                   'Launch Antigravity Agent (agy)'],
      \ 'c': [':Claude',                'Launch Claude Code (claude)'],
      \ 'd': [':Aider',                 'Launch Aider Pair Programmer (aider)'],
      \ 'p': [':PiAgent',               'Launch Pi Coding Agent (pi)'],
      \ 'o': [':Ollama',                'Launch Ollama / DeepSeek'],
      \ 's': [':Copilot status',        'Copilot status'],
      \ 'm': [':Copilot panel',         'Copilot suggestion panel'],
      \ }

" Open in VS Code Bridge
let g:which_key_map.o = {
      \ 'name': '+open/vscode',
      \ 'c': [':OpenInCode',            'Open project in Visual Studio Code'],
      \ 'f': [':OpenInCodeFile',        'Open file at cursor in VS Code'],
      \ }

" Harpoon / File Pins (<Space>m and <Space>1..4)
let g:which_key_map.m = {
      \ 'name': '+marks/pins',
      \ '1': [':PinFile 1', 'Pin current file to slot 1'],
      \ '2': [':PinFile 2', 'Pin current file to slot 2'],
      \ '3': [':PinFile 3', 'Pin current file to slot 3'],
      \ '4': [':PinFile 4', 'Pin current file to slot 4'],
      \ 'l': [':ListPins',  'List all pinned files'],
      \ 'c': [':ClearPins', 'Clear all file pins'],
      \ }
let g:which_key_map['1'] = [':JumpPin 1', 'Jump to pinned file 1']
let g:which_key_map['2'] = [':JumpPin 2', 'Jump to pinned file 2']
let g:which_key_map['3'] = [':JumpPin 3', 'Jump to pinned file 3']
let g:which_key_map['4'] = [':JumpPin 4', 'Jump to pinned file 4']

" Register with vim-which-key
autocmd VimEnter * call which_key#register('<Space>', "g:which_key_map")

" Call which-key on <Space>
nnoremap <silent> <leader> :<C-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<C-u>WhichKeyVisual '<Space>'<CR>

" ------------------------------------------------------------------------------
" 7. PRODUCTIVITY HELPER FUNCTIONS & COMMANDS
" ------------------------------------------------------------------------------

" 1. Terminal Drawer Toggle
let s:term_buf = -1
function! s:ToggleTerminal() abort
  if s:term_buf > 0 && bufexists(s:term_buf)
    let l:win = bufwinnr(s:term_buf)
    if l:win > 0
      execute l:win . 'close'
      return
    endif
  endif
  botright 12split
  if s:term_buf > 0 && bufexists(s:term_buf)
    execute 'buffer ' . s:term_buf
  else
    terminal
    let s:term_buf = bufnr('%')
  endif
  startinsert
endfunction
command! -bar ToggleTerminal call <SID>ToggleTerminal()
nnoremap <silent> <leader>t :ToggleTerminal<CR>

if has('terminal')
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-h> <C-\><C-n><C-w>h
  tnoremap <C-j> <C-\><C-n><C-w>j
  tnoremap <C-k> <C-\><C-n><C-w>k
  tnoremap <C-l> <C-\><C-n><C-w>l
endif

" 2. Copy Path Helpers to Clipboard
function! s:CopyFullPath() abort
  let l:path = expand('%:p')
  if empty(l:path) | echo "No active file" | return | endif
  let @+ = l:path | let @" = l:path
  echo "Copied full path: " . l:path
endfunction

function! s:CopyRelPath() abort
  let l:path = expand('%')
  if empty(l:path) | echo "No active file" | return | endif
  let @+ = l:path | let @" = l:path
  echo "Copied relative path: " . l:path
endfunction

function! s:CopyFileName() abort
  let l:name = expand('%:t')
  if empty(l:name) | echo "No active file" | return | endif
  let @+ = l:name | let @" = l:name
  echo "Copied file name: " . l:name
endfunction

command! -bar CopyFullPath call <SID>CopyFullPath()
command! -bar CopyRelPath call <SID>CopyRelPath()
command! -bar CopyFileName call <SID>CopyFileName()
nnoremap <silent> <leader>yp :CopyFullPath<CR>
nnoremap <silent> <leader>yr :CopyRelPath<CR>
nnoremap <silent> <leader>yn :CopyFileName<CR>

" 3. Smart Code Formatter
function! s:FormatCode() abort
  if exists(':LspFormat') == 2
    LspFormat
    echo "Formatted using LSP"
  else
    let l:save_cursor = getpos(".")
    normal! gg=G
    call setpos('.', l:save_cursor)
    echo "Auto-indented buffer"
  endif
endfunction
command! -bar Format call <SID>FormatCode()
nnoremap <silent> <leader>cf :Format<CR>

" 4. Toggle Quickfix Window
function! s:ToggleQuickfix() abort
  for win in range(1, winnr('$'))
    if getwinvar(win, '&syntax') ==# 'qf'
      cclose
      return
    endif
  endfor
  botright copen
endfunction
command! -bar ToggleQuickfix call <SID>ToggleQuickfix()
nnoremap <silent> <leader>xq :ToggleQuickfix<CR>

" 5. Session Helpers
function! s:SaveSession() abort
  let l:session_dir = expand('~/.vim/sessions')
  if !isdirectory(l:session_dir)
    call mkdir(l:session_dir, 'p')
  endif
  execute 'mksession! ' . l:session_dir . '/last_session.vim'
  echo "Session saved to ~/.vim/sessions/last_session.vim"
endfunction

function! s:RestoreSession() abort
  let l:session_file = expand('~/.vim/sessions/last_session.vim')
  if filereadable(l:session_file)
    execute 'source ' . l:session_file
    echo "Session restored successfully!"
  else
    echo "No saved session found at ~/.vim/sessions/last_session.vim"
  endif
endfunction

command! -bar SaveSession call <SID>SaveSession()
command! -bar RestoreSession call <SID>RestoreSession()
nnoremap <silent> <leader>ss :SaveSession<CR>
nnoremap <silent> <leader>sr :RestoreSession<CR>

" 6. Search & Replace Word Under Cursor
function! s:PromptReplaceWord() abort
  let l:word = expand('<cword>')
  if empty(l:word) | echo "No word under cursor" | return | endif
  call feedkeys(':%s/\<' . l:word . '\>/' . l:word . '/gc', 'n')
endfunction
command! -bar ReplaceWord call <SID>PromptReplaceWord()
nnoremap <silent> <leader>rw :ReplaceWord<CR>

" 7. Health & Status Inspector
function! s:VimHealth() abort
  echo "=========================================================="
  echo "              VIM ENVIRONMENT & HEALTH CHECK              "
  echo "=========================================================="
  echo "• Vim Version       : " . v:version . " (" . (has('vim9script') ? 'Vim9' : 'Legacy') . ")"
  echo "• TrueColor Support : " . (has('termguicolors') ? "✓ Enabled" : "✗ Disabled")
  echo "• System Clipboard  : " . (has('clipboard') ? "✓ Enabled" : "✗ Disabled")
  echo "• Terminal Feature  : " . (has('terminal') ? "✓ Enabled" : "✗ Disabled")
  echo "• Leader Key        : <Space>"
  echo "• Active Plugins    : " . len(glob('~/.vim/plugged/*', 0, 1)) . " plugins loaded"
  echo "• Fuzzy Finder (fzf): " . (executable('fzf') ? "✓ " . exepath('fzf') : "✗ Missing")
  echo "• Ripgrep (rg)      : " . (executable('rg') ? "✓ " . exepath('rg') : "✗ Missing")
  echo "• Persistent Undo   : " . (&undofile ? "✓ Enabled (~/.vim/undodir)" : "✗ Disabled")
  echo "=========================================================="
endfunction
command! -bar VimHealth call <SID>VimHealth()

" 8. Integrated AI Agent Drawer & Launchers
function! s:RunAIAgent(bin, name) abort
  let l:bin_path = executable(a:bin) ? a:bin : (filereadable(expand('~/.local/bin/' . a:bin)) ? expand('~/.local/bin/' . a:bin) : '')
  if empty(l:bin_path)
    echo a:name . " is not found in PATH."
    return
  endif
  botright 14split
  execute 'terminal ' . l:bin_path
  startinsert
endfunction

command! -bar Agy call <SID>RunAIAgent('agy', 'Antigravity CLI (agy)')
command! -bar Claude call <SID>RunAIAgent('claude', 'Claude Code')
command! -bar Aider call <SID>RunAIAgent('aider', 'Aider AI Pair Programmer')
command! -bar PiAgent call <SID>RunAIAgent('pi', 'Pi Coding Agent')
command! -bar Ollama call <SID>RunAIAgent('ollama', 'Ollama')

" Antigravity Code Review & AI Assistance Mappings
nnoremap <silent> <leader>aa :Agy<CR>
nnoremap <silent> <leader>ag :Agy<CR>
nnoremap <silent> <leader>ac :Claude<CR>
nnoremap <silent> <leader>ad :Aider<CR>
nnoremap <silent> <leader>ap :PiAgent<CR>
nnoremap <silent> <leader>ao :Ollama<CR>

" Send current file or visual selection to Antigravity
function! s:AgyReviewCurrentFile() abort
  let l:file = expand('%:p')
  if empty(l:file) | echo "No file to review" | return | endif
  write
  botright 14split
  execute 'terminal /Users/tr/.local/bin/agy "Review ' . l:file . ' for bugs, security, and edge cases"'
  startinsert
endfunction
command! -bar AgyReview call <SID>AgyReviewCurrentFile()
nnoremap <silent> <leader>ar :AgyReview<CR>

" Explain current line or context with Antigravity
function! s:AgyExplainLine() abort
  let l:file = expand('%:p')
  let l:line = line('.')
  let l:text = getline('.')
  botright 14split
  execute 'terminal /Users/tr/.local/bin/agy "In ' . l:file . ' line ' . l:line . ': ''' . escape(l:text, '"\') . ''', explain this code and point out any potential bugs or edge cases"'
  startinsert
endfunction
command! -bar AgyExplain call <SID>AgyExplainLine()
nnoremap <silent> <leader>ae :AgyExplain<CR>

" 9. Open in Visual Studio Code Bridge
function! s:OpenInCode() abort
  let l:dir = getcwd()
  silent execute '!open -a "Visual Studio Code" ' . shellescape(l:dir)
  redraw!
  echo "Opened folder in VS Code: " . l:dir
endfunction

function! s:OpenInCodeFile() abort
  let l:file = expand('%:p')
  let l:line = line('.')
  if empty(l:file)
    call <SID>OpenInCode()
    return
  endif
  silent execute '!open -a "Visual Studio Code" --args -g ' . shellescape(l:file . ':' . l:line)
  redraw!
  echo "Opened file in VS Code at line " . l:line
endfunction

command! -bar OpenInCode call <SID>OpenInCode()
command! -bar OpenInCodeFile call <SID>OpenInCodeFile()
command! -bar Code call <SID>OpenInCode()

nnoremap <silent> <leader>oc :OpenInCode<CR>
nnoremap <silent> <leader>of :OpenInCodeFile<CR>

" 10. Backpropagation, Revert & Window Helpers
command! -bar Undo normal! u
command! -bar Redo execute "normal! \<lt>C-r\>"
command! -bar RevertFile edit!
command! -bar RevertAll bufdo! edit!
command! -bar JumpBack execute "normal! \<lt>C-o\>"
command! -bar JumpForward execute "normal! \<lt>C-i\>"
command! -bar QuitWindow close
command! -bar ForceQuit qa!
command! -bar CloseAllOthers only
command! -nargs=1 -complete=file DiffWith vert diffsplit <args>

" 11. Window Zoom Toggle (Maximize active split / Restore layout)
let s:is_zoomed = 0
function! s:ToggleZoom() abort
  if s:is_zoomed
    wincmd =
    let s:is_zoomed = 0
    echo "Splits restored to normal layout"
  else
    wincmd _
    wincmd |
    let s:is_zoomed = 1
    echo "Window maximized (Press <Space>z to restore splits)"
  endif
endfunction
command! -bar ToggleZoom call <SID>ToggleZoom()
command! -bar Zoom call <SID>ToggleZoom()

" 12. Search Word Under Cursor Across Codebase (Ripgrep)
function! s:RgWordUnderCursor() abort
  let l:word = expand('<cword>')
  if empty(l:word)
    echo "No word under cursor"
    return
  endif
  execute 'Rg ' . l:word
endfunction
command! -bar RgWord call <SID>RgWordUnderCursor()

" 13. Instant Disposable Scratchpad Buffer
function! s:OpenScratchpad() abort
  for win in range(1, winnr('$'))
    if getwinvar(win, '&buftype') ==# 'nofile' && bufname(winbufnr(win)) ==# '[Scratchpad]'
      execute win . 'close'
      return
    endif
  endfor
  botright 10new
  setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
  file [Scratchpad]
  echo "Opened Scratchpad (Type freely - discarded on close without prompts)"
endfunction
command! -bar Scratch call <SID>OpenScratchpad()

" 13b. Daily Developer Journal & Notes (:DailyNote)
function! s:OpenDailyNote() abort
  let l:notes_dir = expand('~/notes')
  if !isdirectory(l:notes_dir)
    call mkdir(l:notes_dir, 'p')
  endif
  let l:today_file = l:notes_dir . '/' . strftime('%Y-%m-%d') . '.md'
  if !filereadable(l:today_file)
    call writefile([
          \ '# 📝 Dev Journal: ' . strftime('%Y-%m-%d'),
          \ '',
          \ '## 🎯 Focus & Priorities',
          \ '- [ ] ',
          \ '',
          \ '## 💡 Notes & Implementation Findings',
          \ '',
          \ '',
          \ '## 🔗 References & Commands',
          \ ''
          \ ], l:today_file)
  endif
  execute 'edit ' . fnameescape(l:today_file)
  echo "📓 Opened Daily Dev Journal: " . strftime('%Y-%m-%d')
endfunction
command! -bar DailyNote call <SID>OpenDailyNote()
command! -bar Note call <SID>OpenDailyNote()

" 14. In-Vim Code & Test Runner (Execute in bottom terminal drawer)
let s:last_run_cmd = ''
function! s:RunCurrentFile() abort
  let l:file = expand('%:p')
  let l:ext  = expand('%:e')
  if empty(l:file)
    echo "No file to run"
    return
  endif
  write
  let l:cmd = ''
  if l:ext ==# 'py'
    let l:cmd = 'python3 ' . shellescape(l:file)
  elseif l:ext ==# 'js'
    let l:cmd = 'node ' . shellescape(l:file)
  elseif l:ext ==# 'ts'
    let l:cmd = 'npx tsx ' . shellescape(l:file)
  elseif l:ext ==# 'sh' || l:ext ==# 'zsh'
    let l:cmd = 'zsh ' . shellescape(l:file)
  elseif l:ext ==# 'lua'
    let l:cmd = 'lua ' . shellescape(l:file)
  elseif l:ext ==# 'go'
    let l:cmd = 'go run ' . shellescape(l:file)
  elseif l:ext ==# 'rs'
    let l:cmd = 'cargo run'
  else
    let l:cmd = input('Command to execute: ')
  endif
  if empty(l:cmd)
    return
  endif
  let s:last_run_cmd = l:cmd
  call s:ExecuteInTerminalDrawer(l:cmd)
endfunction

function! s:RunLastCommand() abort
  if empty(s:last_run_cmd)
    call s:RunCurrentFile()
    return
  endif
  call s:ExecuteInTerminalDrawer(s:last_run_cmd)
endfunction

function! s:ExecuteInTerminalDrawer(cmd) abort
  botright 12split
  execute 'terminal ' . a:cmd
  startinsert
endfunction

command! -bar RunFile call <SID>RunCurrentFile()
command! -bar RunLast call <SID>RunLastCommand()

" 15. Fuzzy Project & Directory Switcher (Zoxide + FZF)
function! s:FzfChangeDirectory() abort
  let l:cmd = 'find . -maxdepth 3 -type d 2>/dev/null'
  if executable('zoxide')
    let l:ztest = system('zoxide query --list 2>/dev/null')
    if !empty(l:ztest) && v:shell_error == 0
      let l:cmd = 'zoxide query --list'
    endif
  endif
  call fzf#run(fzf#wrap({
        \ 'source': l:cmd,
        \ 'sink': function('s:ChangeDirAndRefresh'),
        \ 'options': '--prompt="Jump Project / Directory > "'
        \ }))
endfunction

function! s:ChangeDirAndRefresh(dir) abort
  if empty(a:dir) | return | endif
  execute 'cd ' . fnameescape(a:dir)
  if exists(':NERDTree') && g:NERDTree.IsOpen()
    NERDTreeCWD
  endif
  echo "Working directory changed to: " . a:dir
endfunction

command! -bar CdProject call <SID>FzfChangeDirectory()

" 16. Harpoon-Style File Pinning (<Space>m and <Space>1..4)
let g:file_pins = {}

function! s:PinCurrentFile(slot) abort
  let l:file = expand('%:p')
  if empty(l:file)
    echo "No file to pin"
    return
  endif
  let g:file_pins[a:slot] = l:file
  echo "📌 Pinned [" . a:slot . "]: " . expand('%:t') . " (" . l:file . ")"
endfunction

function! s:JumpToPin(slot) abort
  if !has_key(g:file_pins, a:slot) || empty(g:file_pins[a:slot])
    echo "📌 Pin [" . a:slot . "] is empty. Pin with <Space>m" . a:slot
    return
  endif
  execute 'edit ' . fnameescape(g:file_pins[a:slot])
  echo "📌 Jumped to [" . a:slot . "]: " . expand('%:t')
endfunction

function! s:ListPins() abort
  echo "=========================================================="
  echo "                 PINNED FILES (HARPOON)                   "
  echo "=========================================================="
  for i in [1, 2, 3, 4]
    if has_key(g:file_pins, i) && !empty(g:file_pins[i])
      echo " [" . i . "] " . fnamemodify(g:file_pins[i], ':t') . "  -->  " . g:file_pins[i]
    else
      echo " [" . i . "] (empty)"
    endif
  endfor
  echo "=========================================================="
  echo " Jump: <Space>1..4   |   Pin: <Space>m1..4   |   Clear: <Space>mc"
endfunction

function! s:ClearPins() abort
  let g:file_pins = {}
  echo "📌 All file pins cleared."
endfunction

command! -nargs=1 PinFile call <SID>PinCurrentFile(<args>)
command! -nargs=1 JumpPin call <SID>JumpToPin(<args>)
command! -bar ListPins call <SID>ListPins()
command! -bar ClearPins call <SID>ClearPins()

" 17. Universal Project Task Runner (:RunTask)
function! s:RunProjectTask() abort
  call s:ExecuteInTerminalDrawer('frun')
endfunction
command! -bar RunTask call <SID>RunProjectTask()

" 18. Project Bookmarks Jumping (:Bookmarks / :Bm)
function! s:FzfBookmarks() abort
  let l:bm_file = expand('~/.bookmarks')
  if !filereadable(l:bm_file) || empty(readfile(l:bm_file))
    echo "No bookmarks found in ~/.bookmarks. Add one from terminal with: mark"
    return
  endif
  call fzf#run(fzf#wrap({
        \ 'source': 'awk -F"|" "{printf \"%-20s %s\n\", \$1, \$2}" ' . fnameescape(l:bm_file),
        \ 'sink': function('s:ChangeDirFromBookmark'),
        \ 'options': '--prompt="Jump Bookmarked Project > "'
        \ }))
endfunction

function! s:ChangeDirFromBookmark(line) abort
  let l:dir = split(a:line)[-1]
  if !empty(l:dir) && isdirectory(l:dir)
    execute 'cd ' . fnameescape(l:dir)
    if exists(':NERDTree') && g:NERDTree.IsOpen()
      NERDTreeCWD
    endif
    echo "Warped project directory to: " . l:dir
  endif
endfunction

command! -bar Bookmarks call <SID>FzfBookmarks()
command! -bar Bm call <SID>FzfBookmarks()

" 19. Personal Code Snippets Inserter (:Snippets)
function! s:FzfSnippets() abort
  let l:snip_dir = expand('~/.snippets')
  if !isdirectory(l:snip_dir)
    call mkdir(l:snip_dir, 'p')
  endif
  call fzf#run(fzf#wrap({
        \ 'source': 'find ' . fnameescape(l:snip_dir) . ' -type f -maxdepth 2 -exec basename {} \;',
        \ 'sink': function('s:InsertSnippet'),
        \ 'options': '--prompt="Insert Snippet > " --preview="bat --color=always --line-range :50 ' . fnameescape(l:snip_dir) . '/{} 2>/dev/null || cat ' . fnameescape(l:snip_dir) . '/{}" --preview-window=right:60%'
        \ }))
endfunction

function! s:InsertSnippet(name) abort
  let l:file = expand('~/.snippets/') . a:name
  if filereadable(l:file)
    execute 'read ' . fnameescape(l:file)
    echo "Inserted snippet: " . a:name
  endif
endfunction

command! -bar Snippets call <SID>FzfSnippets()

" ------------------------------------------------------------------------------
" 8. ERGONOMIC KEY MAPPINGS
" ------------------------------------------------------------------------------
" Direct shortcuts for fastest muscle-memory access:
nnoremap <silent> <leader>e  :NERDTreeToggle<CR>
nnoremap <silent> <leader>f  :Files<CR>
nnoremap <silent> <leader>g  :Rg<CR>
nnoremap <silent> <leader>gw :RgWord<CR>
nnoremap <silent> <leader>b  :Buffers<CR>
nnoremap <silent> <leader>bs :Scratch<CR>
nnoremap <silent> <leader>bj :DailyNote<CR>
nnoremap <silent> <leader>w  :w<CR>
nnoremap <silent> <leader>z  :ToggleZoom<CR>
nnoremap <silent> <leader>rf :RunFile<CR>
nnoremap <silent> <leader>rl :RunLast<CR>
nnoremap <silent> <leader>rt :RunTask<CR>
nnoremap <silent> <leader>cd :CdProject<CR>
nnoremap <silent> <leader>cb :Bookmarks<CR>
nnoremap <silent> <leader>cp :Snippets<CR>
nnoremap <silent> <leader>sn :Snippets<CR>
nnoremap <silent> <leader>co :BTags<CR>
nnoremap <silent> <leader>cs :BTags<CR>
nnoremap <silent> <leader>1  :JumpPin 1<CR>
nnoremap <silent> <leader>2  :JumpPin 2<CR>
nnoremap <silent> <leader>3  :JumpPin 3<CR>
nnoremap <silent> <leader>4  :JumpPin 4<CR>
nnoremap <silent> <leader>m1 :PinFile 1<CR>
nnoremap <silent> <leader>m2 :PinFile 2<CR>
nnoremap <silent> <leader>m3 :PinFile 3<CR>
nnoremap <silent> <leader>m4 :PinFile 4<CR>
nnoremap <silent> <leader>ml :ListPins<CR>
nnoremap <silent> <leader>mc :ClearPins<CR>
nnoremap <silent> <leader>?  :Guide<CR>
nnoremap <silent> <F1>        :Guide<CR>

" Command Palette (VS Code style search for any command, tool, or action)
nnoremap <silent> <leader>p        :Commands<CR>
nnoremap <silent> <leader><leader> :Commands<CR>
nnoremap <silent> <leader>:        :Commands<CR>

" Ctrl+p for file finding (popular muscle-memory shortcut)
nnoremap <silent> <C-p> :Files<CR>

" Clear search highlight with double Escape or <leader>/
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" Seamless window navigation across Vim splits AND Tmux panes (Ctrl + h/j/k/l)
function! s:TmuxOrSplitSwitch(wincmd, tmuxdir) abort
  let l:prev_winnr = winnr()
  execute 'wincmd ' . a:wincmd
  if l:prev_winnr == winnr() && !empty($TMUX)
    call system('tmux select-pane -' . a:tmuxdir)
  endif
endfunction

nnoremap <silent> <C-h> :call <SID>TmuxOrSplitSwitch('h', 'L')<CR>
nnoremap <silent> <C-j> :call <SID>TmuxOrSplitSwitch('j', 'D')<CR>
nnoremap <silent> <C-k> :call <SID>TmuxOrSplitSwitch('k', 'U')<CR>
nnoremap <silent> <C-l> :call <SID>TmuxOrSplitSwitch('l', 'R')<CR>

" Resize windows easily with Alt/Option or Ctrl + Arrows
nnoremap <silent> <C-Up>    :resize +2<CR>
nnoremap <silent> <C-Down>  :resize -2<CR>
nnoremap <silent> <C-Left>  :vertical resize -2<CR>
nnoremap <silent> <C-Right> :vertical resize +2<CR>

" Buffer navigation: [b and ]b, or Shift-H / Shift-L
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> <S-l> :bnext<CR>
nnoremap <silent> <S-h> :bprevious<CR>

" Git hunk navigation with GitGutter: ]c and [c
nnoremap <silent> ]c :GitGutterNextHunk<CR>
nnoremap <silent> [c :GitGutterPrevHunk<CR>

" LSP Diagnostic navigation: ]d and [d (Jump next/previous error or warning)
nnoremap <silent> ]d :LspNextDiagnostic<CR>
nnoremap <silent> [d :LspPreviousDiagnostic<CR>
nnoremap <silent> <leader>ce :LspDocumentDiagnostics<CR>
command! -bar LspDiagnostic LspDocumentDiagnostics

" Quickfix list navigation: ]q and [q (Jump next/previous build or grep error)
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [q :cprevious<CR>

" Move lines up and down (Alt/Option + j/k in Normal and Visual modes, auto-indented)
nnoremap <silent> <M-j> :m .+1<CR>==
nnoremap <silent> <M-k> :m .-2<CR>==
vnoremap <silent> <M-j> :m '>+1<CR>gv=gv
vnoremap <silent> <M-k> :m '<-2<CR>gv=gv
nnoremap <silent> <A-j> :m .+1<CR>==
nnoremap <silent> <A-k> :m .-2<CR>==
vnoremap <silent> <A-j> :m '>+1<CR>gv=gv
vnoremap <silent> <A-k> :m '<-2<CR>gv=gv
vnoremap <silent> J :m '>+1<CR>gv=gv
vnoremap <silent> K :m '<-2<CR>gv=gv

" Keep cursor centered when jumping half-page or searching
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" Better indenting in visual mode (keeps selection active for multiple indents)
vnoremap < <gv
vnoremap > >gv

" Safe visual paste: don't lose clipboard buffer when pasting over selected text
xnoremap <silent> p "_dP

" ------------------------------------------------------------------------------
" 9. INTERACTIVE CHEATSHEET & GUIDANCE COMMAND (:Guide / :HelpMe)
" ------------------------------------------------------------------------------
function! s:OpenGuide() abort
  let l:guide_file = expand('~/.vim/GUIDE.txt')
  if filereadable(l:guide_file)
    execute 'botright 18split ' . l:guide_file
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nomodifiable
    setlocal readonly
    setlocal filetype=help
    nnoremap <buffer> <silent> q :close<CR>
    nnoremap <buffer> <silent> <Esc> :close<CR>
  else
    echo "Guide file ~/.vim/GUIDE.txt not found."
  endif
endfunction

command! -bar Guide call <SID>OpenGuide()
command! -bar HelpMe call <SID>OpenGuide()
command! -bar Cheatsheet call <SID>OpenGuide()

" ------------------------------------------------------------------------------
" 10. CONVENIENT CONFIG RELOAD
" ------------------------------------------------------------------------------
command! -bar ReloadConfig source $MYVIMRC | echo "Config reloaded successfully!"
nnoremap <leader>sv :ReloadConfig<CR>
