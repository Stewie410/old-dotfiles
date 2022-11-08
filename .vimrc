" Bootstrap vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"  --
"  -- Plugins
"  --
call plug#begin('~/.vim/plugged')
	" Features
	Plug 'tpope/vim-sensible'
	Plug 'majutsushi/tagbar'
	Plug 'vim-syntastic/syntastic'
	Plug 'mhinz/vim-signify'
	Plug 'junegunn/fzf', {'do': { -> fzf#install()}}
	Plug 'junegunn/fzf.vim'
	Plug 'junegunn/vim-peekaboo'
	Plug 'lervag/vimtex'
	Plug 'lambdalisue/fern.vim'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'jremmen/vim-ripgrep'
	Plug 'vim-airline/vim-airline'
	Plug 'tpope/vim-fugitive'
	Plug 'mbbill/undotree'

	" Pretty"
	Plug 'ryanoasis/vim-devicons'
	Plug 'prettier/vim-prettier', {'do': 'yarn install'}
	Plug 'sheerun/vim-polyglot'
	Plug 'dracula/vim', { 'as': 'dracula' }
	Plug 'chrisbra/unicode.vim'
	Plug 'pprovost/vim-ps1'
	Plug 'vim-airline/vim-airline-themes'
call plug#end()

" -----------------------------------------------------------------------------

" Do not use legacy vi compatability mode
set nocompatible

" Use standard line numbers
set number

" Display character column in status bar
set ruler

" Specify 256-bit color mode
set t_Co=256

" Allow mouse interaction
set mouse=ni

" Show previous commands
set showcmd

" Handle <Tab> better
set smarttab

" Tabs => \s[4}
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab

" Show hidden characters
set list
set listchars=tab:>·,trail:·

" Indentation help
filetype plugin indent on

" Use current line's indentation for next line
set autoindent
set smartindent

" Override the 'ignorecase' option if the search pattern contains UCase
set smartcase

" Reload open file if changed outside of vim
set autoread

" Assume unicode emoji are full width
set emoji

" Enable autocompletion
set wildmode=longest,list,full

" Split -> Right
set splitright

" VSplit -> Down
set splitbelow

" Use a backup file when overwriting a file, but remove it after
" successfully flushing the buffer
set nobackup
set writebackup

" Use incremental searching
set incsearch

" Set mappings for filetypes, rather than globally or per-buffer
filetype plugin on

" Color Theme
colorscheme slate

" Enable syntax highlighting
syntax on

" Allow space for vim-airline
set laststatus=2

" Hide abandoned buffers
"set hidden

" Use N lines for command input
set cmdheight=2

" Don't give completion-menu interactive prompts
set shortmess+=c

" Draw the sign column
set signcolumn=yes

" Define statusline
set statusline^=%{coc#status()]%{get(b:.'coc_current_function'.'')}}

" Get expected behavior of backspace
set backspace=indent,eol,start

" Write to swapfile after N ms if nothing has been typed
" Also used for CursorHold autocommand event
set updatetime=50

" Minimal number of screen lines to keep above & below the cursor
set scrolloff=1

" Minimal number of screen columns to keep to the left & right of the cursor
set sidescrolloff=1

" Include as much as possible of the lastline, but use '@@@' to show
" truncation
set display=lastline

" When autoformatting, remove a comment leader when joinging lines
set formatoptions+=j

" airline: features
let g:airline_powerline_fonts = 1
let g:airline_detect_modified = 1
let g:airline_detect_paste = 1
let g:airline_detect_crypt = 1
let g:airline_detect_iminsert = 0
let g:airline_inactive_collapse = 1
"let g:airline_statusline_ontop = 1

" airline: extensions
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" airline: themee
let g:airline_theme = 'badwolf'

" airline: symbols
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

" airline: unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '85;2u[1F512]'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitspace = 'Ξ'

" airline: powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''

" ctrlp: settings
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" coc.nvim: extensions
let g:coc_global_extensions = [
	\ 'coc-snippets',
	\ 'coc-pairs',
	\ 'coc-tsserver',
	\ 'coc-prettier',
	\ 'coc-eslint',
	\ 'coc-json',
	\ 'coc-highlight',
	\ 'coc-emmet',
	\ 'coc-git',
	\ 'coc-vimlsp',
	\ 'coc-markdownlint',
	\ 'coc-yank',
	\ 'coc-marketplace',
	\ 'coc-sh',
	\ ]

" netrw: <CR> will open the file by vertically splitting the window first
let g:netrw_browse_split = 2

" netrw: suppress informational banner
let g:netrw_banner = 0

" netrw: specify initial width (Vexplore) or height (Hexplore)
let g:netrw_winsize = 25

" vimtex: assume *.tex files are a certain type, unless the first line
" contains '%&<format>' override
let g:tex_flavor = 'latex'

" -----------------------------------------------------------------------------

" User-Mapping leader key
let mapleader = " "

" Don't require <C-w> for navigating splits
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Use the primary registery for copy & paste
noremap <leader>y "*y
noremap <leader>p "*p

" Use the system clipboard for copy & paste
noremap <leader>Y "+y
noremap <leader>P "+p

" Reset Split Sizing
noremap <C-=> <C-w>=

" <C-n> Toggle a Fern buffer in project-drawer style
nmap <C-n> :Fern . -drawer -width=25 -toggle

" Use <Tab> to trigger completion
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<Tab>" : coc#refresh()
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <C-space> to refresh coc.nvim
inoremap <silent><expr> <C-space> coc#refresh()

" Use <CR> to confirm completion
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use '[g' & ']g' to navigate coc.nvim diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Go-To coc.nvim Nodes
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show coc.nvim documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Rename current word with coc.nvim
nmap <leader>rn <Plug>(coc-rename)

" Format selected region with coc.nvim
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

" Peform coc.nvim code action on selected region
xmap <leader>a <Plug>(coc-codeaction-selected)
xmap <leader>ac <Plug>(coc-codeaction)
nmap <leader>a <Plug>(coc-codeaction-selected)

" Resolve autofix issues with coc.nvim
nmap <leader>qf <Plug>(coc-fix-current)

" Support function text-objects with coc.nvim
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)

" Use <C-d> for selection ranges in coc.nvim
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Access various lists in coc.nvim
nnoremap <silent> <space>a :<C-u>CocList diagnostics<cr>
nnoremap <silent> <space>e :<C-u>CocList extensions<cr>
nnoremap <silent> <space>c :<C-u>CocList commands<cr>
nnoremap <silent> <space>o :<C-u>CocList outline<cr>
nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
nnoremap <silent> <space>j :<C-u>CocNext<CR>
nnoremap <silent> <space>k :<C-u>CocPrev<CR>
nnoremap <silent> <space>p :<C-u>CocListResume<CR>

" -----------------------------------------------------------------------------

" Format current buffer with coc.nvim
command! -nargs=0 Format :call CocAction('format')

" Fold current buffer with coc.nvim
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Organize import of current buffer with coc.nvim
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

" Alias for 'filetype detect'
command! FTD filetype detect

" Alias for ToggleTabStop()
command! TTS call ToggleTabStop()

" Highligh symbold under cursor on CursorHold with coc.nvim
autocmd CursorHold * silent call CocActionAsync('highlight')

" Allow comments in JSON
autocmd FileType json syntax match Comment +\/\/.\+$+

" Disable automatic commenting on new lines
"autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Jump to last-known cursor position, unless invalid
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Merge changes into xrdb if Buffer is ~/.X(resources|defaults)
"autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb %

" Trim trailing whitespace on buffer write
autocmd BufWritePre * silent call TrimTrailingWhitespace()

" Trim trailing newlines on buffer write
autocmd BufWritePre * silent call TrimEndLines()

" Filetype Adjustments
augroup AutoFileType
	autocmd!

	" Calcurse
	autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown

	" (G)ROFF
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff

	" LaTeX
	autocmd BufRead,BufNewFile *.tex set filetype=tex

	" Plain-Text files
	"autocmd FileType text setlocal textWidth=80

	" Shell Scripts
	autocmd BufRead,BufNewFile *.sh set filetype=sh
augroup END

" Use Templates if available
augroup TemplateFiles
	autocmd!

	" Shell Scripts
	autocmd BufNewFile *.sh 0r /home/alex/.vim/templates/skeleton.sh

	" CMD/Batch Scripts
	autocmd BufNewFile *.bat 0r /home/alex/.vim/templates/skeleton.bat

	" AutoHotKey
	autocmd BufNewFile *.ahk 0r /home/alex/.vim/tempaltes/skeleton.ahk

	" PowerShell
	autocmd BufNewFile *.ps1 0r /home/alex/.vim/templates/skeleton.ps1
augroup END

" Handle Formatting with coc.nvim
augroup CocFormatting
	autocmd!

	" Setup formatexpr for specified filetypes
	autocmd FileType typescript,json setlocal formatexpr=CocAction('formatSelected')

	" Update signature help on jump placeholder(s)
	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup END

" Initialize Fern
augroup fern-custom
	autocmd!
	autocmd FileType fern call s:init_fern()
augroup END

" -----------------------------------------------------------------------------

" Handle Tab-Navigate with coc.nvim
function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1] =~# '\s'
endfunction

" Show Documentation with coc.nvim
function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h ' . expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction

" Initalize Fern
function! s:init_fern() abort
	nmap <buffer> <Plug>(fern-action-open) <Plug>(fern-action-open:select)
endfunction

" Trim trailing whitespace
function! TrimTrailingWhitespace()
	let l:save = winsaveview()
	keeppatterns %s/\s\+$//e
	call winrestview(l:save)
endfunction

" Trim newlines from EOF
function TrimEndLines()
	let l:save_cursor = getpos(".")
	silent! keeppatterns %s#\($\n\s*\)\+\%$##
	call setpos('.', l:save_cursor)
endfunction

" Toggle Tabs == 4 || 8
function! ToggleTabStop()
	if &tabstop == 4
		silent! set tabstop=8 softtabstop=8 shiftwidth=8
	else
		silent! set tabstop=4 softtabstop=4 shiftwidth=4
	endif
endfunction

" -----------------------------------------------------------------------------
