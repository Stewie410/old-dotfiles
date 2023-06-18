" Disable vi-compatability
set nocompatible

" Line & Column numbers
set number
set ruler

" Color support
set ruler
set termguicolors

" Encoding
set encoding=utf-8

" Mouse interaction
set mouse=a

" Command space
set showcmd
set cmdheight=2

" <Tab>
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smarttab

" Indentation Visualization
set list
set listchars=tab:>·,trail:·

" Filetype detection
filetype plugin indent on

" Splits
set splitbelow
set splitright

" Backupfiles for writing, but don't keep them around
set nobackup
set writebackup

" Search
set incsearch
set hlsearch

" Always show statusline
set laststatus=2

" Forced swapfile writing interval (ms)
set updatetime=50

" Always show the sign Column
set signcolumn=yes

" Leader Key
let mapleader = "\<Space>"
