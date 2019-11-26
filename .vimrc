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
"Plug 'junegunn/goyo.vim'
Plug 'majutsushi/tagbar'
Plug 'PotatoesMaster/i3-vim-syntax'
"Plug 'vimwiki/vimwiki'
"Plug 'chrisbra/csv.vim'
Plug 'vim-syntastic/syntastic'
Plug 'mhinz/vim-signify'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'lervag/vimtex'
Plug 'deviantfero/wpgtk.vim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'ryanoasis/vim-devicons'
Plug 'prettier/vim-prettier', {'do': 'yarn install'}
Plug 'HerringtonDarkholme/yats.vim'
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

" Enable smart-tab
set smarttab

" Enable indenting
set cindent

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

" NERDTree
let g:NERDTreeGitStatusWithFlags=1
let g:NERDTreeIgnore = [
	\ '^node_modules$'
	\ ]

" CTRLP
let g:ctrlp_user_command = [
	\ '.git/',
	\ 'git --git-dir=%s/.git ls-files -oc --exclude-standard'
	\ ]

" COC configuration
let g:coc_global_extensions = [
	\ 'coc-snippets',
	\ 'coc-pairs',
	\ 'coc-tsserver',
	\ 'coc-eslint',
	\ 'coc-prettier',
	\ 'coc-json',
	\ 'coc-highlight',
	\ 'coc-emmet',
	\ 'coc-git',
	\ 'coc-vimlsp',
	\ 'coc-markdownlint',
	\ 'coc-yank',
	\ 'coc-marketplace',
	\ ]
set hidden
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" VIM-Prettier
"let g:prettier#quickfix_enabled = 0
"let g:prettier#quickfix_auto_focus = 0
"let g:prettier#autoformat = 0

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

" NERDTree Toggle
nmap <C-n> :NERDTreeToggle<CR>

" NERDTree Commenter Toggle
vmap ++ <Plug>NERDCommenterToggle
nmap ++ <Plug>NERDCommenterToggle

" COC Use tab for trigger completion with characters ahead and navigate
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other
" plugin(s)
inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ coc#refresh()
inoremap <expr><S-TAB> pumvisbible() ? "\<C-p>" : "\<C-h>"

" Use Ctrl+Space to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Use CarriageReturn to confirm completion, <C-g>u means break undo chain at
" current position.
" COC only does snippet and additional edit on confirm
inoremap <exrp> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use complete_info if your vim supports it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use '[g' and ']g' to navigate COC diagonostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" COC GoTo's
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implentation)
nmap <silent> gr <Plug>(coc-references)

" COC: User 'K' t show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" COC Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" COC Remap for 'format selected region'
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

" COC Remap for doAction on [region/line]
xmap <leader>a <Plug>(coc-codeaction-selected)
xmap <leader>ac <Plug>(coc-codeaction)
nmap <leader>a <Plug>(coc-codeaction-selected)

" COC Fix autofix problem of current line
nmap <leader>qf <Plug>(coc-fix-current)

" COC mappings for function text object, requires document symbols feature of
" languagserver
xmap if <Plug>(coc-funcobj-i)
xmap af <plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <plug>(coc-funcobj-a)

" COC Use Ctrl+D for select selections ranges, needs server support, like:
" 	coc-tsserver
" 	coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" COC Lists
nnoremap <silent> <space>a :<C-u>CocList diagnostics<cr>
nnoremap <silent> <space>e :<C-u>CocList extensions<cr>
nnoremap <silent> <space>c :<C-u>CocList commands<cr>
nnoremap <silent> <space>o :<C-u>CocList outline<cr>
nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
nnoremap <silent> <space>j :<C-u>CocNext<CR>
nnoremap <silent> <space>k :<C-u>CocPrev<CR>
nnoremap <silent> <space>p :<C-u>CocListResume<CR>

" ##------------------------------------##
" #|		Commands		|#
" ##------------------------------------##
" COC Use ':Format' to format current buffer
command! -nargs=0 Format :call CocAction('format')

" COC Use ':Fold' to fold current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" COC Use ':OR' for organize import of current buffer
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.orgazineImport')

" ##--------------------------------------------##
" #|		Single Autocommands		|#
" ##--------------------------------------------##
" COC Highlight smbol under cusor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Highlight currently open buffer in NERDTree
autocmd BufEnter * call SyncTree()

" Highlighting for jsonc format
autocmd FileType json syntax match Comment +\/\/.\+$+

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

" COC Formatting
augroup mygroup
	autocmd!
	
	" Setup formatexpr specified filetype(s)
	autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')

	" Update signature help on jump placeholder
	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" ##------------------------------------##
" #|		Functions		|#
" ##------------------------------------##
" Sync open file with NERDTree
function! IsNERDTreeOpen()
	return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind if (all):
" 	NERDTree is active
" 	Current window contains a writable file
" 	Not in a vimdiff
function! SyncTree()
	if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !diff
		NERDTreeFind
		wincmd p
	endif
endfunction

" COC Tab-navigation
function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1] =~# '\s'
endfunction

" COC Show Documentation
function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction

" ##------------------------------------##
" #|		Snippets		|#
" ##------------------------------------##
