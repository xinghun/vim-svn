"Show the Subversion 'blame' annotation for the current file, in a narrow
"  window to the left of it.
"Usage:
"  'gb' or ':Blame'
"  To get rid of it, close or delete the annotation buffer.
"Bugs:
"  If the source file buffer has unsaved changes, these aren't noticed and
"    the annotations won't align properly. Should either warn or preferably
"    annotate the actual buffer contents rather than the last saved version.
"Possible enhancements:
"  When invoked on a revnum in a Blame window, re-blame same file up to the
"    previous revision.
"  Dynamically synchronize when edits are made to the source file.
function s:svnBlame()
   let file = @%
   let line = line(".")
   setlocal nowrap
   let winnr = bufwinnr('^_svnblame$')
   if (winnr < 0)
       " create a new window at the left-hand side
       aboveleft 35vnew _svnblame
   else
       " re-use the existing one if it still exists
       execute winnr . 'wincmd w'
   endif

   " blame
   setlocal noreadonly
   execute "%!svn blame " . "-v " . file
   setlocal nomodified readonly buftype=nofile nowrap winwidth=1
   setlocal nonumber
   if has('&relativenumber') | setlocal norelativenumber | endif

   " return to original line
   exec "normal " . line . "G"

   " synchronize scrolling, and return to original window
   setlocal scrollbind
   setlocal cursorbind
   wincmd p
   setlocal scrollbind
   setlocal cursorbind
   syncbind
endfunction

map sb :call <SID>svnBlame()<CR>
command Blame call s:svnBlame()

function s:svnLog()
    let ret = system("svn log -l3 ".expand("%"))
    echo ret
endfunction
map sl :call <SID>svnLog()<CR>
command Log call s:svnLog()
