" Vim plugin for showing matching parens
" Maintainer:	The Vim Project <https://github.com/vim/vim>
" Last Change:	2025 Apr 08
" Former Maintainer:	Bram Moolenaar <Bram@vim.org>

" Exit quickly when:
" - this plugin was already loaded (or disabled)
" - when 'compatible' is set
" - Vim has no support for :defer
if exists("g:loaded_matchparen") || &cp || exists(":defer") != 2
  finish
endif
let g:loaded_matchparen = 1

if !exists("g:matchparen_timeout")
  let g:matchparen_timeout = 300
endif
if !exists("g:matchparen_insert_timeout")
  let g:matchparen_insert_timeout = 60
endif
if !exists("g:matchparen_disable_cursor_hl")
  let g:matchparen_disable_cursor_hl = 0
endif

augroup matchparen
  " Replace all matchparen autocommands
  autocmd! CursorMoved,CursorMovedI,WinEnter,WinScrolled * call s:Highlight_Matching_Pair()
  autocmd! BufWinEnter * autocmd SafeState * ++once call s:Highlight_Matching_Pair()
  autocmd! WinLeave,BufLeave * call s:Remove_Matches()
  autocmd! TextChanged,TextChangedI * call s:Highlight_Matching_Pair()
  autocmd! TextChangedP * call s:Remove_Matches()
augroup END

" Skip the rest if it was already done.
if exists("*s:Highlight_Matching_Pair")
  finish
endif

let s:cpo_save = &cpo
set cpo-=C

" The function that is invoked (very often) to define a ":match" highlighting
" for any matching paren.
func s:Highlight_Matching_Pair()
  if !exists("w:matchparen_ids")
    let w:matchparen_ids = []
  endif
  " Remove any previous match.
  call s:Remove_Matches()

  " Avoid that we remove the popup menu.
  " Return when there are no colors (looks like the cursor jumps).
  if pumvisible() || (&t_Co < 8 && !has("gui_running"))
    return
  endif

  " Get the character under the cursor and check if it's in 'matchpairs'.
  let c_lnum = line('.')
  let c_col = col('.')
  let before = 0

  let text = getline(c_lnum)
  let c_before = text->strpart(0, c_col - 1)->slice(-1)
  let c = text->strpart(c_col - 1)->slice(0, 1)
  let plist = split(&matchpairs, '.\zs[:,]')
  let i = index(plist, c)
  if i < 0
    " not found, in Insert mode try character before the cursor
    if c_col > 1 && (mode() == 'i' || mode() == 'R')
      let before = strlen(c_before)
      let c = c_before
      let i = index(plist, c)
    endif
    if i < 0
      " not found, nothing to do
      return
    endif
  endif

  " Figure out the arguments for searchpairpos().
  if i % 2 == 0
    let s_flags = 'nW'
    let c2 = plist[i + 1]
  else
    let s_flags = 'nbW'
    let c2 = c
    let c = plist[i - 1]
  endif
  if c == '['
    let c = '\['
    let c2 = '\]'
  endif

  " Find the match.  When it was just before the cursor move it there for a
  " moment.
  if before > 0
    let save_cursor = getcurpos()
    call cursor(c_lnum, c_col - before)
    defer setpos('.', save_cursor)
  endif

  if !has("syntax") || !exists("g:syntax_on")
    let s_skip = "0"
  else
    " do not attempt to match when the syntax item where the cursor is
    " indicates there does not exist a matching parenthesis, e.g. for shells
    " case statement: "case $var in foobar)"
    "
    " add the check behind a filetype check, so it only needs to be
    " evaluated for certain filetypes
    if ['sh']->index(&filetype) >= 0 &&
        \ synstack(".", col("."))->indexof({_, id -> synIDattr(id, "name")
        \ =~? "shSnglCase"}) >= 0
      return
    endif
    " Build an expression that detects whether the current cursor position is
    " in certain syntax types (string, comment, etc.), for use as
    " searchpairpos()'s skip argument.
    " We match "escape" for special items, such as lispEscapeSpecial, and
    " match "symbol" for lispBarSymbol.
    let s_skip = 'synstack(".", col("."))'
        \ . '->indexof({_, id -> synIDattr(id, "name") =~? '
        \ . '"string\\|character\\|singlequote\\|escape\\|symbol\\|comment"}) >= 0'
    " If executing the expression determines that the cursor is currently in
    " one of the syntax types, then we want searchpairpos() to find the pair
    " within those syntax types (i.e., not skip).  Otherwise, the cursor is
    " outside of the syntax types and s_skip should keep its value so we skip
    " any matching pair inside the syntax types.
    " Catch if this throws E363: pattern uses more memory than 'maxmempattern'.
    try
      execute 'if ' . s_skip . ' | let s_skip = "0" | endif'
    catch /^Vim\%((\a\+)\)\=:E363/
      " We won't find anything, so skip searching, should keep Vim responsive.
      return
    endtry
  endif

  " Limit the search to lines visible in the window.
  let stoplinebottom = line('w$')
  let stoplinetop = line('w0')
  if i % 2 == 0
    let stopline = stoplinebottom
  else
    let stopline = stoplinetop
  endif

  " Limit the search time to 300 msec to avoid a hang on very long lines.
  " This fails when a timeout is not supported.
  if mode() == 'i' || mode() == 'R'
    let timeout = exists("b:matchparen_insert_timeout") ? b:matchparen_insert_timeout : g:matchparen_insert_timeout
  else
    let timeout = exists("b:matchparen_timeout") ? b:matchparen_timeout : g:matchparen_timeout
  endif
  try
    let [m_lnum, m_col] = searchpairpos(c, '', c2, s_flags, s_skip, stopline, timeout)
  catch /E118/
    " Can't use the timeout, restrict the stopline a bit more to avoid taking
    " a long time on closed folds and long lines.
    " The "viewable" variables give a range in which we can scroll while
    " keeping the cursor at the same position.
    " adjustedScrolloff accounts for very large numbers of scrolloff.
    let adjustedScrolloff = min([&scrolloff, (line('w$') - line('w0')) / 2])
    let bottom_viewable = min([line('$'), c_lnum + &lines - adjustedScrolloff - 2])
    let top_viewable = max([1, c_lnum-&lines+adjustedScrolloff + 2])
    " one of these stoplines will be adjusted below, but the current values are
    " minimal boundaries within the current window
    if i % 2 == 0
      if has("byte_offset") && has("syntax_items") && &smc > 0
	let stopbyte = min([line2byte("$"), line2byte(".") + col(".") + &smc * 2])
	let stopline = min([bottom_viewable, byte2line(stopbyte)])
      else
	let stopline = min([bottom_viewable, c_lnum + 100])
      endif
      let stoplinebottom = stopline
    else
      if has("byte_offset") && has("syntax_items") && &smc > 0
	let stopbyte = max([1, line2byte(".") + col(".") - &smc * 2])
	let stopline = max([top_viewable, byte2line(stopbyte)])
      else
	let stopline = max([top_viewable, c_lnum - 100])
      endif
      let stoplinetop = stopline
    endif
    let [m_lnum, m_col] = searchpairpos(c, '', c2, s_flags, s_skip, stopline)
  endtry

  " If a match is found setup match highlighting.
  if m_lnum > 0 && m_lnum >= stoplinetop && m_lnum <= stoplinebottom
    if !g:matchparen_disable_cursor_hl
      call add(w:matchparen_ids, matchaddpos('MatchParen', [[c_lnum, c_col - before], [m_lnum, m_col]], 10))
    else
      call add(w:matchparen_ids, matchaddpos('MatchParen', [[m_lnum, m_col]], 10))
    endif
    let w:paren_hl_on = 1
  endif
endfunction

func s:Remove_Matches()
  if exists('w:paren_hl_on') && w:paren_hl_on
    while !empty(w:matchparen_ids)
      silent! call remove(w:matchparen_ids, 0)->matchdelete()
    endwhile
    let w:paren_hl_on = 0
  endif
endfunc

" Define commands that will disable and enable the plugin.
command DoMatchParen call s:DoMatchParen()
command NoMatchParen call s:NoMatchParen()

func s:NoMatchParen()
  let w = winnr()
  noau windo call s:Remove_Matches()
  unlet! g:loaded_matchparen
  exe "noau ". w . "wincmd w"
  au! matchparen
endfunc

func s:DoMatchParen()
  runtime plugin/matchparen.vim
  let w = winnr()
  silent windo doau CursorMoved
  exe "noau ". w . "wincmd w"
endfunc

let &cpo = s:cpo_save
unlet s:cpo_save
