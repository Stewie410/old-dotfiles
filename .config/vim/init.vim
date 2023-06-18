let s:data_path = '~/.config/vim/'
let s:definitions = [
	\ 'options.vim',
	\ 'plugins/init.vim',
	\ 'colorscheme.vim',
	\ 'function.vim',
	\ 'keymap.vim'
	\ ]

for i in s:definitions
	execute "source " . expand(s:data_path) . "/" . i
endfor
