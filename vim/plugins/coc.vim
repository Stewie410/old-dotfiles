let g:coc_global_extensions = [
    \ 'coc-docker',
    \ 'coc-emmet',
    \ 'coc-eslint',
    \ 'coc-git',
    \ 'coc-highlight',
    \ 'coc-html',
    \ 'coc-json',
    \ 'coc-ltex',
    \ 'coc-markdownlint',
    \ 'coc-marketplace',
    \ '@yaegassy/coc-nginx',
    \ 'coc-snippets',
    \ 'coc-pairs',
    \ 'coc-powershell',
    \ 'coc-prettier',
    \ 'coc-sh',
    \ 'coc-spell-checker',
    \ 'coc-sql',
    \ 'coc-texlab',
    \ 'coc-tsserver',
    \ 'coc-vimlsp',
    \ 'coc-yaml',
    \ 'coc-yank',
    \ ]

let g:coc_disable_startup_warning = 1
let g:coc_filetype_map = {
    \ 'tex': 'latex'
    \ }

if has_key(plugs, 'vim-airline')
    let g:airline#extensions#coc#enabled = 1
    let g:airline#extensions#coc#show_coc_status = 1
    let g:airline#extensions#coc#error_symbol = ''
    let g:airline#extensions#coc#warning_symbol = ''
    "let g:airline#extensions#coc#stl_format_err = '%C(L%L)'
    "let g:airline#extensions#coc#stl_format_warn = '%C(L%L)'
else
    set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
endif

command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call CocAction('fold', <f-args>)
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

autocmd CursorHold * silent call CocActionAsync('highlight')

augroup CocFormatting
    autocmd!
    autocmd FileType typescript,json setlocal formatexpr=CocAction('formatSelected')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup END

function! CocShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction

function! CocCheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~# '\s'
endfunction

" completion
inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#pum#next(1) :
    \ CocCheckBackspace() ? "\<Tab>" :
    \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" refresh
inoremap <silent><expr> <C-@> coc#refresh()

" diagnostics
nmap <silent> <leader>[g <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>]g <Plug>(coc-diagnostic-next)

" goto
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gt <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)

" documentation
nnoremap <silent> <leader>K :call CocShowDocumentation()<CR>

" rename
nmap <leader>rn <Plug>(coc-rename)

" format region
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

" code action
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>ac <Plug>(coc-codeaction-cursor)
nmap <leader>as <Plug>(cmc-codeaction-source)

" resolve autofix issues
nmap <leader>qf <Plug>(coc-fix-current)

" refactor
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" codelens action
nmap <leader>cl <Plug>(coc-codelens-action)

" text objects
xmap <leader>if <Plug>(coc-funcobj-i)
omap <leader>if <Plug>(coc-funcobj-i)
xmap <leader>af <Plug>(coc-funcobj-a)
omap <leader>af <Plug>(coc-funcobj-a)

xmap <leader>ic <Plug>(coc-classobj-i)
omap <leader>ic <Plug>(coc-classobj-i)
xmap <leader>ac <Plug>(coc-classobj-a)
omap <leader>ac <Plug>(coc-classobj-a)

" scroll float windows/popups
if has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float_scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float_scroll(0) : "\<C-b>"

    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<C-r>=coc#float#scroll(1)\<CR>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<C-r>=coc#float#scroll(0)\<CR>" : "\<Right>"

    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float_scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float_scroll(0) : "\<C-b>"
endif

" selection ranges
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" lists
nnoremap <silent> <leader>cla :<C-u>CocList diagnostics<CR>
nnoremap <silent> <leader>cle :<C-u>CocList extensions<CR>
nnoremap <silent> <leader>clc :<C-u>CocList commands<CR>
nnoremap <silent> <leader>clo :<C-u>CocList outline<CR>
nnoremap <silent> <leader>cls :<C-u>CocList -I symbols<CR>
nnoremap <silent> <leader>clj :<C-u>CocNext<CR>
nnoremap <silent> <leader>clk :<C-u>CocPrev<CR>
nnoremap <silent> <leader>clp :<C-u>CocListResume<CR>
