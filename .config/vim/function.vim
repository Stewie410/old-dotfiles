command! FTD filetype detect
command! TTS call s:toggle_tab_stop()

autocmd BufNewFile *.sh filetype detect

augroup HotReloadConfig
	autocmd!
	autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb %
augroup END

augroup FiletypeChanges
	autocmd!
	autocmd BufRead,BufNewFile /tmp/calcurs*,~/.calcurse/notes/* set filetype=markdown
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
	autocmd BufRead,BufNewFile *.tex set filetype=tex
	autocmd BufRead,BufNewFile *.sh set filetype=sh
	autocmd BufRead,BufNewFile *.ahk set filetype=ahk
augroup END

augroup CommentSupport
	autocmd!
	autocmd FileType json syntax match Comment +\/\/.\+$+
augroup END

augroup TemplateFiles
	autocmd!
	autocmd BufNewFile *.sh  0r ~/.config/templates/template.sh
	autocmd BufNewFile *.bat 0r ~/.config/templates/template.bat
	autocmd BufNewFile *.ahk 0r ~/.config/templates/template.ahk
	autocmd BufNewFile *.ps1 0r ~/.config/templates/template.ps1
augroup END

function! s:toggle_tab_stop()
	let s:w = &tabstop == 4 ? "8" : "4"
	silent! "execute set tabstop=" . s:w . " softtabstop=" . s:w . " shiftwidth=" . s:w
endfunction
