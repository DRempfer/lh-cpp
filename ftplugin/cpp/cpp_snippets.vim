"=============================================================================
" File:		ftplugin/cpp/cpp_snippets.vim                            {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" License:      GPLv3 with exceptions
"               <URL:http://code.google.com/p/lh-vim/wiki/License>
" Version:	2.1.6
" Created:	15th Apr 2008
" Last Update:	03rd Nov 2015
"------------------------------------------------------------------------
" Description:	Snippets of C++ Control Statements
"
"------------------------------------------------------------------------
" History:
" for changelog: 13th Dec 2005 -> little bug in vmaps for ,,sc ,,rc ,,dc ,,cc
" for changelog: 15th Feb 2006 -> abbr for firend -> friend
" for changelog: 10th Apr 2006 -> "typename" after commas as well
" for changelog: 12th Jun 2006 -> <m-t> is not expanded in comments/string
" }}}1
"=============================================================================

" Buffer-local Definitions {{{1
" Avoid local reinclusion {{{2
if (exists("b:loaded_ftplug_cpp_snippets") && !exists('g:force_reload_ftplug_cpp_snippets')) || lh#option#get("lh_cpp_snippets", 1, "g") == 0
  finish
endif
let s:cpo_save=&cpo
set cpo&vim
" Avoid local reinclusion }}}2

"------------------------------------------------------------------------
" This must be loaded before continuing
runtime! ftplugin/c/c_snippets.vim

" Local mappings {{{2
"
"------------------------------------------------------------------------
" Some C++ abbreviated Keywords {{{3
" ------------------------------------------------------------------------
" TODO: check whether the line is empty
Inoreab <buffer> pub <c-r>='public'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')<cr>
Inoreab <buffer> pro <c-r>='protected'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')<cr>
Inoreab <buffer> pri <c-r>='private'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')<cr>

Iabbr <buffer> tpl template <

inoreab <buffer> vir virtual
cnoreab          firend friend
inoreab <buffer> firend friend
inoreab <buffer> delate delta

inoremap <buffer> <m-s> std::
inoremap <buffer> <expr> <m-b> (getline('.')=~'#\s*include') ? 'boost/' : 'boost::'
inoremap <buffer> <expr> <m-n> lh#cpp#snippets#current_namespace("\<m-n>")
" We don't want � (\hat o) to be expanded in comments)
inoremap <buffer> <m-t> <c-r>=lh#map#insert_seq('<m-t>', '\<c-r\>=lh#cpp#snippets#typedef_typename()\<cr\>')<cr>


"------------------------------------------------------------------------
" Control statements {{{3
"------------------------------------------------------------------------
"--- namespace ---------------------------------------------------{{{4
"--,ns insert "namespace" statement
  Inoreabbr <buffer> namespace <C-R>=lh#cpp#snippets#insert_if_not_after('namespace ',
	\ '\<c-f\>namespace <+namespace+>{<++>}// namespace <+namespace+>', 'using')<cr>
  " Inoreabbr <buffer> namespace <C-R>=lh#cpp#snippets#insert_if_not_after('namespace ',
	" \ '\<c-f\>namespace !cursorhere! {!mark!}!mark!', 'using')<cr>
  vnoremap <buffer> <silent> <LocalLeader>ns
	\ <c-\><c-n>@=lh#dev#style#surround('namespace !cursorhere!{', '!mark!}!mark!',
	\ 0, 1, '', 1, 'namespace ')<cr>
      nmap <buffer> <LocalLeader>ns V<LocalLeader>ns

"--- try ---------------------------------------------------------{{{4
"--try insert "try" statement
  command! -nargs=0 PrivateCppSearchTry :call search('try\_s*{\_s*\zs$', 'b')
  " Inoreabbr <buffer> <silent> try <C-R>=lh#cpp#snippets#def_abbr('try ',
        " \ '\<c-f\>try{!cursorhere!}catch(!mark!){!mark!}!mark!\<esc\>')<CR>
  Inoreabbr <buffer> <silent> try <C-R>=lh#cpp#snippets#def_abbr('try ',
        \ '\<c-f\>try{}catch(!mark!){!mark!}!mark!\<esc\>'
        \ .':PrivateCppSearchTry\<cr\>a\<c-f\>')<CR>
        "
	" \ .'?try\\_s*\\zs{\<cr\>:PopSearch\<cr\>o')<CR>
	" pb with prev. line: { is replaced by \n when c_nl_before_curlyB=1
	"
	" pb with next line: !cursorhere! is badly indented
	" \ '\<c-f\>try {!cursorhere!} catch (!mark!) {!mark!}!mark!')<cr>
"--,try insert "try - catch" statement
  vnoremap <buffer> <LocalLeader>try
	\ <c-\><c-n>@=lh#dev#style#surround('try{!cursorhere!', '!mark!}catch(!mark!){!mark!}',
	\ 0, 1, '', 1, 'try ')<cr>
      nmap <buffer> <LocalLeader>try V<LocalLeader>try

"--- catch -------------------------------------------------------{{{4
"--catch insert "catch" statement
  Inoreabbr <buffer> catch <C-R>=lh#cpp#snippets#def_abbr('catch ',
	\ '\<c-f\>catch(!cursorhere!){!mark!}!mark!')<cr>
  vnoremap <buffer> <LocalLeader>catch
	\ <c-\><c-n>@=lh#dev#style#surround('catch(!cursorhere!){', '!mark!}',
	\ 0, 1, '', 1, 'catch ')<cr>
      nmap <buffer> <LocalLeader>catch V<LocalLeader>catch
  vnoremap <buffer> <LocalLeader><LocalLeader>catch
	\ <c-\><c-n>@=lh#dev#style#surround('catch(', '!cursorhere!){!mark!}',
	\ 0, 1, '', 1, 'catch ')<cr>
      nmap <buffer> <LocalLeader><LocalLeader>catch V<LocalLeader><LocalLeader>catch

"------------------------------------------------------------------------
" Castings {{{3
"------------------------------------------------------------------------
"--- dynamic_cast ------------------------------------------------{{{4
"--dc insert "dynamic_cast" keyword
  vnoremap <buffer> <LocalLeader>dc
	\ <c-\><c-n>@=lh#dev#style#surround('dynamic_cast<!cursorhere!>(', '!mark!)',
	\ 0, 0, '', 1, 'dynamic_cast<')<cr>
      nmap <buffer> <LocalLeader>dc viw<LocalLeader>dc

  vnoremap <buffer> <LocalLeader><LocalLeader>dc
	\ <c-\><c-n>:'<,'>call <sid>ConvertToCPPCast('dynamic_cast')<cr>
      nmap <buffer> <LocalLeader><LocalLeader>dc viw<LocalLeader><LocalLeader>dc
"
"--- reinterpret_cast --------------------------------------------{{{4
"--rc insert "reinterpret_cast" keyword
  vnoremap <buffer> <LocalLeader>rc
	\ <c-\><c-n>@=lh#dev#style#surround('reinterpret_cast<!cursorhere!>(', '!mark!)',
	\ 0, 0, '', 1, 'reinterpret_cast<')<cr>
      nmap <buffer> <LocalLeader>rc viw<LocalLeader>rc

  vnoremap <buffer> <LocalLeader><LocalLeader>rc
	\ <c-\><c-n>:'<,'>call <sid>ConvertToCPPCast('reinterpret_cast')<cr>
      nmap <buffer> <LocalLeader><LocalLeader>rc viw<LocalLeader><LocalLeader>rc
"
"--- static_cast -------------------------------------------------{{{4
"--sc insert "static_cast" keyword
  vnoremap <buffer> <LocalLeader>sc
	\ <c-\><c-n>@=lh#dev#style#surround('static_cast<!cursorhere!>(', '!mark!)',
	\ 0, 0, '', 1, 'static_cast<')<cr>
      nmap <buffer> <LocalLeader>sc viw<LocalLeader>sc

  vnoremap <buffer> <LocalLeader><LocalLeader>sc
	\ <c-\><c-n>:'<,'>call <sid>ConvertToCPPCast('static_cast')<cr>
      nmap <buffer> <LocalLeader><LocalLeader>sc viw<LocalLeader><LocalLeader>sc
"
"--- const_cast --------------------------------------------------{{{4
"--cc insert "const_cast" keyword
  vnoremap <buffer> <LocalLeader>cc
	\ <c-\><c-n>@=lh#dev#style#surround('const_cast<!cursorhere!>(', '!mark!)',
	\ 0, 0, '', 1, 'const_cast<')<cr>
      nmap <buffer> <LocalLeader>cc viw<LocalLeader>cc

  vnoremap <buffer> <LocalLeader><LocalLeader>cc
	\ <c-\><c-n>:'<,'>call <sid>ConvertToCPPCast('const_cast')<cr>
      nmap <buffer> <LocalLeader><LocalLeader>cc viw<LocalLeader><LocalLeader>cc
"

" Misc {{{3
"--- Comments ; Javadoc/DOC++/Doxygen style ----------------------{{{4
" /**       inserts /** <cursor>
"                    */
" but only outside the scope of C++ comments and strings
  " inoremap <buffer> /**  <c-r>=lh#cpp#snippets#def_map('/**',
	" \ '/**\<cr\>\<BS\>/\<up\>\<end\> ',
	" \ '/**\<cr\>\<BS\>/!mark!\<up\>\<end\> ')<cr>
  inoreab <buffer> /** <c-r>=lh#cpp#snippets#def_abbr('/**', '/**!cursorhere!/!mark!')<cr>
" /*<space> inserts /** <cursor>*/
  " inoremap <buffer> /*!  <c-r>=lh#cpp#snippets#def_map('/* ',
	" \ '/** */\<left\>\<left\>',
	" \ '/** */!mark!\<esc\>F*i')<cr>
  inoreab <buffer> /*! <c-r>=lh#cpp#snippets#def_abbr('/*!', '/**!cursorhere!*/!mark!')<cr>

"--- Std oriented stuff-------------------------------------------{{{4
" In std::foreach and std::find algorithms, ..., expand 'algo(container�)'
" into:
" todo: rely on omap-param
" - 'algo(container.begin(),container.end()�)',
inoremap <c-x>be .<esc>%v%<left>o<right>y%%ibegin(),<esc>paend()<esc>a
" - 'algo(container.rbegin(),container.rend()�)',
inoremap <c-x>rbe .<esc>%v%<left>o<right>y%%irbegin(),<esc>parend()<esc>a

" '�' represents the current position of the cursor.

" Local commands {{{2

"=============================================================================
" Global Definitions {{{1
" Avoid global reinclusion {{{2
if exists("g:loaded_ftplug_cpp_snippets") && !exists('g:force_reload_ftplug_cpp_snippets')
  let &cpo=s:cpo_save
  finish
endif
" Avoid global reinclusion }}}2
"------------------------------------------------------------------------
" Functions {{{2
" See autoload/lh/cpp/snippets.vim

function! s:ConvertToCPPCast(cast_type)
  " Extract text to convert
  let save_a = @a
  normal! gv"ay
  " Strip the possible brackets around the expression
  let expr = matchstr(@a, '^(.\{-})\zs.*$')
  let expr = substitute(expr, '^(\(.*\))$', '\1', '')
  "
  " Build the C++-casting from the C casting
  let new_cast = substitute(@a, '(\(.\{-}\)).*',
	\ a:cast_type.'<\1>('.escape(expr, '\&').')', '')
  " Do the replacement
  exe "normal! gvs".new_cast."\<esc>"
  let @a = save_a
endfunction

" Functions }}}2
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
