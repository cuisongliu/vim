" Test using the window ID.

func Test_win_getid()
  edit one
  let id1 = win_getid()
  let w:one = 'one'
  split two
  let id2 = win_getid()
  let bufnr2 = bufnr('%')
  let w:two = 'two'
  split three
  let id3 = win_getid()
  let w:three = 'three'
  tabnew
  edit four
  let id4 = win_getid()
  let w:four = 'four'
  split five
  let id5 = win_getid()
  let bufnr5 = bufnr('%')
  let w:five = 'five'
  tabnext

  wincmd w
  call assert_equal("two", expand("%"))
  call assert_equal(id2, win_getid())
  let nr2 = winnr()
  wincmd w
  call assert_equal("one", expand("%"))
  call assert_equal(id1, win_getid())
  let nr1 = winnr()
  wincmd w
  call assert_equal("three", expand("%"))
  call assert_equal(id3, win_getid())
  let nr3 = winnr()
  call assert_equal('one', getwinvar(id1, 'one'))
  call assert_equal('two', getwinvar(id2, 'two'))
  call assert_equal('three', getwinvar(id3, 'three'))
  tabnext
  call assert_equal("five", expand("%"))
  call assert_equal(id5, win_getid())
  let nr5 = winnr()
  wincmd w
  call assert_equal("four", expand("%"))
  call assert_equal(id4, win_getid())
  let nr4 = winnr()
  call assert_equal('four', getwinvar(id4, 'four'))
  call assert_equal('five', getwinvar(id5, 'five'))
  call settabwinvar(1, id2, 'two', '2')
  call setwinvar(id4, 'four', '4')
  tabnext
  call assert_equal('4', gettabwinvar(2, id4, 'four'))
  call assert_equal('five', gettabwinvar(2, id5, 'five'))
  call assert_equal('2', getwinvar(id2, 'two'))

  exe nr1 . "wincmd w"
  call assert_equal(id1, win_getid())
  exe nr2 . "wincmd w"
  call assert_equal(id2, win_getid())
  exe nr3 . "wincmd w"
  call assert_equal(id3, win_getid())
  tabnext
  exe nr4 . "wincmd w"
  call assert_equal(id4, win_getid())
  exe nr5 . "wincmd w"
  call assert_equal(id5, win_getid())

  call win_gotoid(id2)
  call assert_equal("two", expand("%"))
  eval id4->win_gotoid()
  call assert_equal("four", expand("%"))
  call win_gotoid(id1)
  call assert_equal("one", expand("%"))
  call win_gotoid(id5)
  call assert_equal("five", expand("%"))

  call assert_equal(0, win_id2win(9999))
  call assert_equal(nr5, id5->win_id2win())
  call assert_equal(0, win_id2win(id1))
  tabnext
  call assert_equal(nr1, win_id2win(id1))

  call assert_equal([0, 0], win_id2tabwin(9999))
  call assert_equal([1, nr2], id2->win_id2tabwin())
  call assert_equal([2, nr4], win_id2tabwin(id4))

  call assert_equal([], win_findbuf(9999))
  call assert_equal([id2], bufnr2->win_findbuf())
  call win_gotoid(id5)
  split
  call assert_equal(sort([id5, win_getid()]), sort(win_findbuf(bufnr5)))

  call assert_fails('let w = win_getid([])', 'E745:')
  call assert_equal(0, win_getid(-1))
  call assert_equal(-1, win_getid(1, -1))

  only!
endfunc

func Test_win_getid_curtab()
  CheckFeature quickfix

  tabedit X
  tabfirst
  copen
  only
  call assert_equal(win_getid(1), 1->win_getid( 1))
  tabclose!
endfunc

func Test_winlayout()
  let w1 = win_getid()
  call assert_equal(['leaf', w1], winlayout())

  split
  let w2 = win_getid()
  call assert_equal(['col', [['leaf', w2], ['leaf', w1]]], winlayout())

  split
  let w3 = win_getid()
  call assert_equal(['col', [['leaf', w3], ['leaf', w2], ['leaf', w1]]], winlayout())

  2wincmd w
  vsplit
  let w4 = win_getid()
  call assert_equal(['col', [['leaf', w3], ['row', [['leaf', w4], ['leaf', w2]]], ['leaf', w1]]], winlayout())

  only!

  let w1 = win_getid()
  call assert_equal(['leaf', w1], winlayout(1))
  tabnew
  let w2 = win_getid()
  call assert_equal(['leaf', w2], 2->winlayout())
  tabclose

  call assert_equal([], winlayout(-1))
endfunc

" vim: shiftwidth=2 sts=2 expandtab
