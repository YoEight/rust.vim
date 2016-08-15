" Vim syntastic plugin
" Language:     Rust
" Maintainer:   Andrew Gallant <jamslam@gmail.com>
"
" See for details on how to add an external Syntastic checker:
" https://github.com/scrooloose/syntastic/wiki/Syntax-Checker-Guide#external

if exists("g:loaded_syntastic_rust_rustc_checker")
    finish
endif
let g:loaded_syntastic_rust_rustc_checker = 1

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_rust_rustc_GetLocList() dict
    let makeprg = self.makeprgBuild({ 'args': '-Zparse-only' })

    " Old errorformat (before nightly 2016/08/10)
    let errorformat  =
        \ '%E%f:%l:%c: %\d%#:%\d%# %.%\{-}error:%.%\{-} %m,'   .
        \ '%W%f:%l:%c: %\d%#:%\d%# %.%\{-}warning:%.%\{-} %m,' .
        \ '%C%f:%l %m,' .
        \ '%-Z%.%#'
        
    " New errorformat (after nightly 2016/08/10)
    let errorformat  .=
        \ ',' .
        \ '%Eerror: %m,' .
        \ '%Eerror[E%n]: %m,' .
        \ '%Wwarning: %m,' .
        \ '%Inote: %m,' .
        \ '%C %#--> %f:%l:%c,' .
        \ '%C%.%#'
        

    return SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'rust',
    \ 'name': 'rustc'})

let &cpo = s:save_cpo
unlet s:save_cpo
