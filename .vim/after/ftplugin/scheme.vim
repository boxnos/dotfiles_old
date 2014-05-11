" for GUI
vmap <buffer> <C-CR> :call <SID>EvalVisual()<CR>
nmap <buffer> <C-CR> :call <SID>EvalNormal()<CR>

nmap <silent> <buffer> <A-i> :exe "normal A ; " . <SID>Readirect(function("<SID>EvalNormal"))<CR>
vmap <silent> <buffer> <A-i> :exe "normal A ; " . <SID>Readirect(function("<SID>EvalVisual"))<CR>

" for CUI
vmap <buffer> <Leader>e :call <SID>EvalVisual()<CR>
nmap <buffer> <Leader>e :call <SID>EvalNormal()<CR>
nmap <silent> <buffer> <Leader>c :exe "normal A ; " . <SID>Readirect(function("<SID>EvalNormal"))<CR>
vmap <silent> <buffer> <Leader>c :exe "normal A ; " . <SID>Readirect(function("<SID>EvalVisual"))<CR>


function! s:Readirect(Fn)
  let tmp = ""

  redir => tmp
  silent call a:Fn()
  redir END

  return substitute(tmp, '\n', '', '')
endfunc

function! s:EvalNormal()
    let line = line('.')
    let col = col('.')
    silent normal %

    let saved_reg = @"
    silent normal y%
    execute 'mzscheme ' . @"
    let @" = saved_reg

    call cursor(line, col)
endfunction

function! s:EvalVisual() range
    let saved_reg = @"
    silent normal `<v`>y
    execute 'mzscheme ' . @"
    let @" = saved_reg
endfunction

if has("mzscheme")
:mz << EOF
(require (prefix-in vim- 'vimext))

(current-library-collection-paths
  (cons
    (build-path (find-system-path 'addon-dir) (version) "collects")
    (current-library-collection-paths)))

;(current-library-collection-paths
;  (map (lambda (p) (if (bytes? p) (bytes->path p) p))
;    (current-library-collection-paths)))

(current-directory (bytes->string/locale (vim-eval "expand(\"%:p:h\")")))

(require (lib "trace.ss"))
(require (lib "process.ss"))
(require srfi/1)

; http://pre.racket-lang.org/racket/collects/compatibility/defmacro.rkt
(require (for-syntax racket/base syntax/stx))
(require compatibility/defmacro) ; defmacro, define-macro

; (define (square x) (* x x))
EOF
endif

setl lispwords=define,lambda,let,let*,letrec

"setl lispwords+=and,or,if,cond,case
setl lispwords+=begin,do,delay,set!,else,=>
setl lispwords+=quote,quasiquote,unquote,unquote-splicing
setl lispwords+=define-syntax,let-syntax,letrec-syntax,syntax-rules
setl lispwords+=module,define-macro
