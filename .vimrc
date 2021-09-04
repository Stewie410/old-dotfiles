" ~/.vimrc
"
" Vim Configuration

"  --
"  -- Plugins
"  --
call plug#begin('~/.vim/plugged')
    Plug 'PotatoesMaster/i3-vim-syntax'
    Plug 'vim-syntastic/syntastic'
    Plug 'mhinz/vim-signify'
    Plug 'junegunn/fzf', {'do': { -> fzf#install()}}
    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/vim-peekaboo'
    Plug 'lervag/vimtex'
    Plug 'lambdalisue/fern.vim'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'ryanoasis/vim-devicons'
    Plug 'prettier/vim-prettier', {'do': 'yarn install'}
    Plug 'jremmen/vim-ripgrep'
    Plug 'tpope/vim-fugitive'
    Plug 'vim-utils/vim-man'
    Plug 'mbbill/undotree'
    Plug 'sheerun/vim-polyglot'
    Plug 'dracula/vim', { 'as': 'dracula' }
call plug#end()

"  --
"  -- Options
"  --
" Enable
set number
set ruler
set showcmd
set cindent
set hidden
set smarttab
set smartindent
set smartcase
set splitbelow splitright
set expandtab
set autoread
set undofile

" Disable
set noerrorbells
set nobackup
set nowritebackup
set noswapfile
set noemoji

"  --
"  -- Variables
"  --
" Globals
let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_winsize = 25

" Plugin Globals
let g:vimwiki_ext2syntax = {
    \ '.Rmd': 'markdown',
    \ '.rmd': 'markdown',
    \ '.md': 'markdown',
    \ '.mdown':
    \ 'markdown',
    \ '.markdown':
    \ 'markdown'
    \ }
let g:airline_powerline_fonts = 1
let g:airline_detect_modified = 1
let g:airline_detect_paste = 1
let g:airline_detect_crypt = 1
let g:airline_detect_iminsert = 0
let g:airline_inactive_collapse = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'term'
let g:airline_left_sep = ''
let g:airline_left_alt_sep = '|'
let g:airline_right_sep = ''
let g:airline_right_alt_sep = '|'
"let g:airline_symbols.crypt = '!'
let g:airline_readonly = 'R'
let g:airline_linenr = 'L'
let g:airline_branch = 'B'
let g:airline_paste = 'P'
let g:airline_notexists = 'E'
"let g:airline_whitespace '_'
let g:ctrlp_use_caching = 0
let g:ctrlp_user_command = [
	\ '.git/',
	\ 'git --git-dir=%s/.git ls-files -oc --exclude-standard'
	\ ]
let g:coc_global_extensions = [
	\ 'coc-snippets',
	\ 'coc-pairs',
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
"let g:prettier#quickfix_enabled = 0
"let g:prettier#quickfix_auto_focus = 0
"let g:prettier#autoformat = 0
let g:tex_flavor = 'latex'

" Local
set mouse=r
set t_Co=256
set encoding=utf-8
set tabstop=4 softtabstop=4
set shiftwidth=4
set cmdheight=2
set updatetime=50
set shortmess+=c
set signcolumn=yes
set undodir=~/.vim/undodir
set backspace=indent,eol,start
set wildmode=longest,list,full
set complete-=1
set laststatus=2
set scrolloff=1
set sidescrolloff=1
set display+=lastline
set sessionoptions-=options
set viewoptions-=options
set shortmess+=c
set colorcolumn=80
set background=dark
set formatoptions+=j
set history=1000
set tabpagemax=50
set viminfo^=!
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Additional
"set termguicolors
colo slate
let g:airline_theme = "dracula"
syntax on
"hi Normal guibg=NONE ctermbg=NONE
"hi NonText ctermbg=NONE
filetype plugin indent on
highlight ColorColumn ctermbg=8 guibg=lightgray

" Conditionals
if executable('rg')
    let g:rg_derive_root='true'
endif

"  --
"  -- Keymaps
"  --
" Leader Key
let mapleader =" "

" Split navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Copy/Paste to Primary [yp] & Clipboard [YP]
noremap <leader>y "*y
noremap <leader>p "*p
noremap <leader>Y "+y
noremap <leader>P "+p

" fern
nmap <C-n> :Fern . -drawer

" MatchIT
if !exists('f:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
    runtime! macros/matchit.vim
    if empty(mapcheck('<C-U>', 'i'))
        inoremap <C-U> <C-G>u<C-U>
    endif
    if empty(mapcheck('<C-W>', 'i'))
        inoremap <C-W. <C-G>u<C-W>
    endif
endif

"  --
"  -- Commands
"  --
" COC
command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call CocAction('fold', <f-args>)
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.orgazineImport')

" Tab Compatibility
command! TC :set tabstop=8 softtabstop=8 shiftwidth=8

"  --
"  -- Autocommands
"  --
" COC Highlight symbol under cusor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Highlighting for jsonc format
autocmd FileType json syntax match Comment +\/\/.\+$+

" Trim Whitespace
autocmd BufWritePre * :call TrimWhitespace()

" fern
augroup fern-custom
    autocmd! *
    autocmd FileType fern call s:init_fern()
augroup END

" Use YCM & COC for different filetype
autocmd FileType cpp,cxx,h,hpp,c,py,shell,typescript :call GoCOC()

" Filetypes
augroup AutoFiletype
	autocmd!
	autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
	autocmd BufRead,BufNewFile *.tex set filetype=tex
augroup END

" Templates
augroup Templates
	autocmd BufNewFile *.sh 0r ~/.vim/templates/skeleton.sh
augroup END

" Update xrdb
augroup AutoXrdb
	autocmd!
	autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb %
augroup END

" Update vim
augroup AutoVimrc
    autocmd!
    autocmd BufWritePost source %
augroup END

"  --
"  -- Functions
"  --
" Trim Whitespace
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

" fern
function! s:init_fern() abort
    nmap <buffer> <Plug>(fern-action-open) <Plug>(fern-action-open:select)
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

" YCM Keymaps
fun! GoYCM()
    " YCM Go-To
    nnoremap <buffer> <silent> <leader>gd :YcmCompleter GoTo<CR>
    nnoremap <buffer> <silent> <leader>gr :YcmCompleter GoToReferences<CR>
    nnoremap <buffer> <silent> <leader>rr :YcmCompleter RefactorRename<space>
endfun

" CoC Keymaps
fun! GoCOC()
    " COC Use tab for trigger completion with characters ahead and navigate
    " Use command ':verbose imap <tab>' to make sure tab is not mapped by
    " plugin(s)
    inoremap <buffer> <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
    inoremap <buffer> <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    " Use Ctrl+Space to trigger completion
    inoremap <buffer> <silent><expr> <C-space> coc#refresh()

    " Use CarriageReturn to confirm completion, <C-g>u means break undo chain at
    " current position.
    " COC only does snippet and additional edit on confirm
    inoremap <exrp> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    " Or use complete_info if your vim supports it, like:
    "inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

    " Use '[g' and ']g' to navigate COC diagonostics
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

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

    " COC Go-To
    nmap <buffer> <leader>gd <Plug>(coc-definition)
    nmap <buffer> <leader>gy <Plug>(coc-type-definition)
    nmap <buffer> <leader>gi <Plug>(coc-implementation)
    nmap <buffer> <leader>gr <Plug>(coc-references)
    nnoremap <buffer> <leader>cr :CocRestart

    " COC Formatting
    augroup mygroup
    	autocmd!
    	autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end
endfun

"  --
"  -- Snippets
"  --
