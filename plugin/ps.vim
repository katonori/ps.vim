" Copyright (c) 2013, katonori(katonori.d@gmail.com) All rights reserved.
" 
" Redistribution and use in source and binary forms, with or without modification, are
" permitted provided that the following conditions are met:
" 
"   1. Redistributions of source code must retain the above copyright notice, this list
"      of conditions and the following disclaimer.
"   2. Redistributions in binary form must reproduce the above copyright notice, this
"      list of conditions and the following disclaimer in the documentation and/or other
"      materials provided with the distribution.
"   3. Neither the name of the katonori nor the names of its contributors may be used to
"      endorse or promote products derived from this software without specific prior
"      written permission.
" 
" THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
" EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
" OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
" SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
" INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
" TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
" BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
" CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
" ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
" DAMAGE.

if !exists("g:PS_PsCmd")
    let g:PS_PsCmd = "ps aux"
endif
if !exists("g:PS_KillCmd")
    let g:PS_KillCmd = "kill -9"
endif
if !exists("g:PS_RegExRule")
    let g:PS_RegExRule = '\w\+\s\+\zs\d\+\ze'
endif

function! s:OpenProcLine()
    let l:line = getline(".")
    let l:str = matchstr(l:line, g:PS_RegExRule, 0)
    call s:OpenProc(l:str)
endfunction

function! s:OpenProc(str)
    let l:dir = "/proc/" . a:str
    if a:str != "" && isdirectory(l:dir)
        bel vnew
        exec "e " . l:dir
    else
        echo "ERROR: " . l:dir  . " is not found"
    endif
endfunction

function! s:KillLine()
    let l:line = getline(".")
    let l:str = matchstr(l:line, g:PS_RegExRule, 0)
    call s:KillProcess(l:str)
endfunction

function! s:KillAllLines() range
    let l:start = line("'<")
    let l:end = line("'>")
    let l:lines = getline(l:start, l:end)
    for l:l in l:lines
        let l:str = matchstr(l:l, g:PS_RegExRule, 0)
        call s:KillProcess(l:str)
    endfor
endfunction

function! s:KillWord()
    normal yiw
    call s:KillProcess(@")
endfunction

function! s:KillProcess(num)
    let l:cmd = g:PS_KillCmd . " " . a:num
    let l:res = system(l:cmd)
    if v:shell_error != 0
        echo "ERROR: command execution failed.: " . l:cmd
        return
    endif
    silent call s:Refresh()
    echo l:res
    echo "Process " . a:num . " has been killed."
endfunction

function! s:Refresh()
    let l:line = line(".")
    exec "%delete"
    exec "0read !" . g:PS_PsCmd
    exec ":" . l:line
endfunction

function! s:Init()
    nnoremap <buffer> <silent> r :PsRefresh<CR>
    nnoremap <buffer> <silent> <C-K> :PsKillLine<CR>
    vnoremap <buffer> <silent> <C-K> :PsKillAllLines<CR>
    nnoremap <buffer> <silent> p :PsOpenProcLine<CR>
    nnoremap <buffer> <silent> K :PsKillWord<CR>
    nnoremap <buffer> <silent> q :q!<CR>

    setlocal buftype=nofile
    exec "source $VIMRUNTIME/syntax/sh.vim"
endfunction

command! -nargs=0 PsRefresh :call s:Refresh()
command! -nargs=0 PsKillLine :call s:KillLine()
command! -nargs=0 -range PsKillAllLines :call s:KillAllLines()
command! -nargs=0 PsKillWord :call s:KillWord()
command! -nargs=0 PsOpenProcLine :call s:OpenProcLine()
command! -nargs=0 PsThisBuffer :set filetype=ps | :call s:Init() | :PsRefresh
command! -nargs=0 PS :new | :PsThisBuffer
