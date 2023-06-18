syntax on

try
	colorscheme ayu
catch /^Vim\%((\a\+)\)\=:E185/
	set notermguicolors
	colorscheme slate
endtry
