let s:data_dir = '~/.vim'
let s:config_dir = '~/.config/vim/plugins'

if empty(glob(s:data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo ' . data_dir . '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(s:data_dir . '/plugged')

" Universal Settings
Plug 'tpope/vim-sensible'

" Colorschemes
Plug 'ayu-theme/ayu-vim'

" Statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" VCS
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify', { 'tag': 'legacy' }
"Plug data_dir . '/local/vcscommand'

" LSP (or similar)
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-ragtag'
Plug 'sheerun/vim-polyglot'

" Filetype support
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'pprovost/vim-ps1', { 'for': [ 'ps1', 'psd1', 'psm1', 'pssc', 'ps1xml', 'xml' ] }
Plug 'tpope/vim-markdown', { 'for': 'md' }
Plug 'tpope/vim-jdaddy', { 'for': 'json' }

" Various
Plug 'junegunn/vim-easy-align'
Plug 'chrisbra/unicode.vim'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-speeddating'

call plug#end()

" Load configs
let s:plugin_confs = [
	\ 'airline.vim',
	\ 'coc.vim',
	\ 'easy-align.vim'
	\ ]

for i in s:plugin_confs
	execute "source " . s:config_dir . "/" . i
endfor
