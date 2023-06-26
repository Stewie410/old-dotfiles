syntax on

" ugly workaround for tmux 24-bit color
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

try
	colorscheme ayu
catch /^Vim\%((\a\+)\)\=:E185/
	set notermguicolors
	colorscheme slate
endtry
