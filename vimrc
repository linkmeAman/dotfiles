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

" Natural window splitting
set splitbelow                 " Open new horizontal splits below
set splitright                 " Open new vertical splits to the right

" Performance and responsiveness
set updatetime=300             " Faster gitgutter updates and hover popups (default 4000ms)
set timeoutlen=500             " Quicker response for mapped sequences
set ttimeoutlen=50

" System clipboard integration (macOS pbcopy/pbpaste seamless)
if has('clipboard')
  set clipboard^=unnamed,unnamedplus
endif

" Mouse support for scrolling, selecting, and clicking
if has('mouse')
  set mouse=a
endif

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
if exists('+viminfofile')
  let &viminfofile = expand('~/.vim/viminfo')
else
  set viminfo+=n~/.vim/viminfo
endif

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

" Lightline statusbar
let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
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

" ------------------------------------------------------------------------------
" 6. WHICH-KEY & INTERACTIVE GUIDANCE
" ------------------------------------------------------------------------------
let g:which_key_use_floating_win = 1
let g:which_key_max_size = 0

" Define leader mappings dictionary for vim-which-key
let g:which_key_map = {}

" Top-level actions
let g:which_key_map['?'] = [ ':Guide',            'Open cheatsheet guide' ]
let g:which_key_map['w'] = [ ':w',                'Save file' ]
let g:which_key_map['q'] = [ ':q',                'Quit' ]
let g:which_key_map['Q'] = [ ':qa!',              'Force quit all' ]
let g:which_key_map['u'] = [ ':UndotreeToggle',   'Toggle undo history tree' ]
let g:which_key_map['/'] = [ ':nohlsearch',       'Clear search highlight' ]
let g:which_key_map['t'] = [ ':ToggleTerminal',   'Toggle terminal drawer' ]

" File & Explorer
let g:which_key_map.e = {
      \ 'name': '+explorer',
      \ 'e': [':NERDTreeToggle',       'Toggle file tree'],
      \ 'f': [':NERDTreeFind',         'Find current file in tree'],
      \ 'r': [':NERDTreeRefreshRoot',  'Refresh tree'],
      \ }

" Fuzzy Finder (fzf)
let g:which_key_map.f = {
      \ 'name': '+find/fuzzy',
      \ 'f': [':Files',       'Search files in project'],
      \ 'g': [':Rg',          'Search text in project (Ripgrep)'],
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
      \ 'p': [':GitGutterPreviewHunk', 'Preview git hunk at cursor'],
      \ 'u': [':GitGutterUndoHunk',    'Undo git hunk at cursor'],
      \ 'a': [':GitGutterStageHunk',   'Stage git hunk at cursor'],
      \ }

" Buffers
let g:which_key_map.b = {
      \ 'name': '+buffer',
      \ 'd': [':bdelete',     'Delete/close current buffer'],
      \ 'n': [':bnext',       'Next buffer'],
      \ 'p': [':bprevious',   'Previous buffer'],
      \ 'l': [':Buffers',     'List/find buffers'],
      \ }

" Windows
let g:which_key_map.v = {
      \ 'name': '+windows',
      \ 's': [':split',       'Horizontal split'],
      \ 'v': [':vsplit',      'Vertical split'],
      \ 'c': [':close',       'Close window'],
      \ 'o': [':only',        'Close all other windows'],
      \ '=': ['<C-w>=',       'Equalize window sizes'],
      \ }

" Code & LSP
let g:which_key_map.c = {
      \ 'name': '+code/lsp',
      \ 'd': [':LspDefinition',         'Go to definition'],
      \ 'r': [':LspReferences',         'Find references'],
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

" Refactor / Replace
let g:which_key_map.r = {
      \ 'name': '+refactor',
      \ 'w': [':ReplaceWord', 'Search & replace word under cursor'],
      \ }

" Settings, Sessions & System
let g:which_key_map.s = {
      \ 'name': '+settings/session',
      \ 'v': [':ReloadConfig',          'Reload .vimrc configuration'],
      \ 's': [':SaveSession',           'Save workspace session'],
      \ 'r': [':RestoreSession',        'Restore workspace session'],
      \ 'o': [':Obsession',             'Toggle continuous session tracker'],
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

nnoremap <silent> <leader>ag :Agy<CR>
nnoremap <silent> <leader>ac :Claude<CR>
nnoremap <silent> <leader>ad :Aider<CR>
nnoremap <silent> <leader>ap :PiAgent<CR>
nnoremap <silent> <leader>ao :Ollama<CR>

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

" ------------------------------------------------------------------------------
" 8. ERGONOMIC KEY MAPPINGS
" ------------------------------------------------------------------------------
" Direct shortcuts for fastest muscle-memory access:
nnoremap <silent> <leader>e  :NERDTreeToggle<CR>
nnoremap <silent> <leader>f  :Files<CR>
nnoremap <silent> <leader>g  :Rg<CR>
nnoremap <silent> <leader>b  :Buffers<CR>
nnoremap <silent> <leader>w  :w<CR>
nnoremap <silent> <leader>q  :q<CR>
nnoremap <silent> <leader>u  :UndotreeToggle<CR>
nnoremap <silent> <leader>?  :Guide<CR>

" Ctrl+p for file finding (popular muscle-memory shortcut)
nnoremap <silent> <C-p> :Files<CR>

" Clear search highlight with Escape or <leader><space>
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
nnoremap <silent> <leader><Space> :nohlsearch<CR>

" Seamless window navigation with Ctrl + h/j/k/l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

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

" Move lines up and down visually (Alt+j / Alt+k or J/K in visual mode)
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Keep cursor centered when jumping half-page or searching
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" Better indenting in visual mode (keeps selection)
vnoremap < <gv
vnoremap > >gv

" Don't lose paste buffer when pasting over a visual selection
vnoremap p "_dP

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
