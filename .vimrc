" ~/.vimrc
" Author:	Alex Paarfus <stewie410@me.com>
" Date:		2019-02-03
"
" Based on:
" 	- My preferences, over time
" 	- Luke Smith's vimrc (but not a lot)
" 	- https://www.reddit.com/r/vim/wiki/vimrctips

" ##----------------------------##
" #|		Plugins		|#
" ##----------------------------##
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'junegunn/goyo.vim'
Plug 'majutsushi/tagbar'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'vimwiki/vimwiki'
Plug 'chrisbra/csv.vim'
Plug 'vim-syntastic/syntastic'
Plug 'mhinz/vim-signify'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'lervag/vimtex'
Plug 'deviantfero/wpgtk.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
call plug#end()


" ##------------------------------------##
" #|		Settings		|#
" ##------------------------------------##
" Line Numbers and Ruler
set number
set ruler

" Color and Encoding
set t_Co=256
set encoding=utf-8

" Allow Mouse
set mouse=r

" Show partial command 
set showcmd

" Enable autocompletion
set wildmode=longest,list,full

" Splits to split down or right
set splitbelow splitright

" Set mappings for filetypes, rather than globally (per buffer)
"filetype plugin on

" Vim Colorscheme and Syntax Highlighting
colo ron
"colo wpgtk
"colo default
syntax on

" Transparency Workaround
hi Normal guibg=NONE ctermbg=NONE
hi NonText ctermbg=NONE

" Disable automatic commenting on new line
"autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Ensure some files are read as expected
let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown', '.md': 'markdown', '.mdown': 'markdown', '.markdown': 'markdown'}

" Enable AIrline
set laststatus=2

" Airline Features
let g:airline_powerline_fonts = 1
let g:airline_detect_modified = 1
let g:airline_detect_paste = 1
let g:airline_detect_crypt = 1
let g:airline_detect_iminsert = 0
let g:airline_inactive_collapse = 1

" Airline Extensions
let g:airline#extensions#tabline#enabled = 1

" Airline Theme
"let g:airline_theme = 'wombat'
let g:airline_theme = 'term'

" Airline Fallbacks
let g:airline_left_sep = ''
let g:airline_left_alt_sep = '|'
let g:airline_right_sep = ''
let g:airline_right_alt_sep = '|'
"let g:airline_symbols.crypt = '!'
"let g:airline_readonly = 'R'
"let g:airline_linenr = ''
"let g:airline_branch = 'B'
"let g:airline_paste = 'P'
"let g:airline_notexists = ''
"let g:airline_whitespace ''


" ##----------------------------##
" #|		Keymaps		|#
" ##----------------------------##
" Leader Key
let mapleader ="\\"

" Enable goyo
"noremap <leader>f :Goyo \| set linebreak<CR>

" Spellcheck -- 'o' for 'orthography'
"noremap <leader>o :setlocal spell! spelllang=en_us<CR>

" Split navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Check file in shellcheck
"noremap <leader>s :!clear && shellcheck %<CR>

" Aliase to replace-all
"nnoremap S :%s//g<Left><Left>

" Compile document
"noremap <leader>c :w! \| !compiler <C-r>%<CR><CR>

" Open .pdf/.html preview
"noremap <leader>p :!opout <C-r>%<CR><CR>

" Use urlscan to choose and open a URL
":noremap <leader>u :w<Home> !urlscan -r 'linkhandler {}'<CR>
":noremap ,, !urlscan -r 'linkhandler {}'<CR>

" Copy selected text to system clipboard (might req gvim/nvim/vim-x11)
"vnoremap <C-c> "+y
"noremap <C-p> "+P

" Navigating with guides
"inoremap <Space><Tab> <Esc>/<++><Enter>"_c4l
"vnoremap <Space><Tab> <Esc>/<++><Enter>"_c4l
"noremap <Space><Tab> <Esc>/<++><Enter>"_c4l


" ##--------------------------------------------##
" #|		autocmd(-groups)		|#
" ##--------------------------------------------##
" Filetypes
augroup AutoFiletype
	" Remove all auto-commands from the group "AutoFiletype"
	autocmd!

	" Calcurse
	autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
	" Groff
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff

	" La-/Tex
	autocmd BufRead,BufNewFile *.tex set filetype=tex
augroup END


" Update xrdb
augroup AutoXrdb
	autocmd!
	" Run xrdb whenever Xdefaults or Xresources are updated
	autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb %
augroup END


" ##------------------------------------##
" #|		Snippets		|#
" ##------------------------------------##
