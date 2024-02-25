" # Vim 8.2 < patch 3434 handling: {{{
" If sourced from < Vim 8.2 patch 3434, set a static statusline only.
" :h vim9-mix and :h tene-Vim-8
if (v:version < 802 || (v:version == 802 && !has('patch3434')))
  " The warning requires popups, which were only a thing from v801 patch 1705.
  if exists('g:tene_8warn') && (v:version == 802 || (v:version == 801 && has('patch1705')))
    let winid = popup_menu(split(printf('%22s','WARNING|') ..
          \ ' vim-tene only works with either|' ..
          \ 'Vim 9 or Vim 8.2 with patch 3434.|' ..
          \ 'A static statusline will be set.','|'),#{time: 5000})
  endif
  if v:version > 701
    set statusline=\ %-4.(%{mode(1)}%)\ b%n%<\ %t\ %m\ %r\ %h%=%y\ %{&fileencoding}\ %{&fileformat}\ ¶%l/%L\ \|%v\ U+%B
  endif
  finish
endif
" }}}
vim9script
# Dictionaries and Variables {{{
# Configurable highlighting.  See :h tene-highlighting
g:tene_hi = exists("g:tene_hi") ? g:tene_hi : {}
# Configurable mode names.  See :h tene-config-mode-names
g:tene_modes = exists("g:tene_modes") ? g:tene_modes : {}
# Configurable indicators.  See :h tene-config-ga
g:tene_ga = exists("g:tene_ga") ? g:tene_ga : {}
g:tene_ga['buftypehelp'] = has_key(g:tene_ga, 'buftypehelp') ? g:tene_ga['buftypehelp'] : ['[help]', '']
g:tene_ga['bufnr'] = has_key(g:tene_ga, 'bufnr') ? g:tene_ga['bufnr'] : ['b', 'в']
g:tene_ga['winnr'] = has_key(g:tene_ga, 'winnr') ? g:tene_ga['winnr'] : ['w', 'ш']
g:tene_ga['paste'] = has_key(g:tene_ga, 'paste') ? g:tene_ga['paste'] : ['P', '']
g:tene_ga['mod'] =  has_key(g:tene_ga, 'mod') ? g:tene_ga['mod'] : ['[+]', '']
g:tene_ga['noma'] =  has_key(g:tene_ga, 'noma') ? g:tene_ga['noma'] : ['[-]', '']
g:tene_ga['pvw'] = has_key(g:tene_ga, 'pvw') ? g:tene_ga['pvw'] : ['[Preview]', '']
g:tene_ga['dg'] = has_key(g:tene_ga, 'dg') ? g:tene_ga['dg'] : ['^K', 'Æ']
g:tene_ga['key'] = has_key(g:tene_ga, 'key') ? g:tene_ga['key'] : ['E', '']
g:tene_ga['spell'] = has_key(g:tene_ga, 'spell') ? g:tene_ga['spell'] : ['S', '']
g:tene_ga['recording'] = has_key(g:tene_ga, 'recording') ? g:tene_ga['recording'] : ['@', '']
g:tene_ga['ro'] = has_key(g:tene_ga, 'ro') ? g:tene_ga['ro'] : ['[RO]', '']
g:tene_ga['line()'] = has_key(g:tene_ga, 'line()') ? g:tene_ga['line()'] : ['_', '']
g:tene_ga['col()'] = has_key(g:tene_ga, 'col()') ? g:tene_ga['col()'] : ['c', '']
g:tene_ga['virtcol()'] = has_key(g:tene_ga, 'virtcol()') ? g:tene_ga['virtcol()'] : ['|', '']
g:tene_state_S = exists("g:tene_state_S") ? g:tene_state_S : ' I ' # :h tene-config-state-S
# Binary variables for toggling features. See :h tene-config-toggles
g:tene_buffer_num = exists("g:tene_buffer_num") ? g:tene_buffer_num : 1
g:tene_file_tail = exists("g:tene_file_tail") ? g:tene_file_tail : 1
g:tene_glyphs = exists("g:tene_glyphs") ? g:tene_glyphs : 1
g:tene_keymap = exists("g:tene_keymap") ? g:tene_keymap : 1
g:tene_line_num = exists("g:tene_line_num") ? g:tene_line_num : 1
g:tene_line_nums = exists("g:tene_line_nums") ? g:tene_line_nums : 1
g:tene_virtcol = exists("g:tene_virtcol") ? g:tene_virtcol : 1
g:tene_unicode = exists("g:tene_unicode") ? g:tene_unicode : 1
g:tene_col = exists("g:tene_col") ? g:tene_col : 0
g:tene_hl_group = exists("g:tene_hl_group") ? g:tene_hl_group : 0
g:tene_mode = exists("g:tene_mode") ? g:tene_mode : 0
g:tene_modestate = exists("g:tene_modestate") ? g:tene_modestate : 0
g:tene_path = exists("g:tene_path") ? g:tene_path : 0
g:tene_percent = exists("g:tene_percent") ? g:tene_percent : 0
g:tene_window_num = exists("g:tene_window_num") ? g:tene_window_num : 0
# }}}
# Autocommand group {{{
augroup tene
  autocmd!
  # :h tene-autocommand  :h ModeChanged   :h redrawstatus
  autocmd ModeChanged *:[^t]\+ redrawstatus
augroup END
# }}}
# Statusline commands {{{
set statusline=
# :h mode() (NB: its order is followed)  :h tene-config-mode-names
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'n'?'%#'..get(g:tene_hi,'n','Visual')..'#\ '..(g:tene_mode==1?'n\ ':get(g:tene_modes,'n','NORMAL')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'no'?'%#'..get(g:tene_hi,'o','ErrorMsg')..'#\ '..(g:tene_mode==1?'no\ ':get(g:tene_modes,'no','OP\ PENDING')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'nov'?'%#'..get(g:tene_hi,'o','ErrorMsg')..'#\ '..(g:tene_mode==1?'nov\ ':get(g:tene_modes,'nov','OP\ PENDING\ (v)')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'noV'?'%#'..get(g:tene_hi,'o','ErrorMsg')..'#\ '..(g:tene_mode==1?'noV\ ':get(g:tene_modes,'noV','OP\ PENDING\ (V)')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'no'?'%#'..get(g:tene_hi,'o','ErrorMsg')..'#\ '..(g:tene_mode==1?'no^V\ ':get(g:tene_modes,'noCTRL-V','OP\ PENDING\ (^V)')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'niI'?'%#'..get(g:tene_hi,'n','Visual')..'#\ '..(g:tene_mode==1?'niI\ ':get(g:tene_modes,'niI','INSERT\ (NORMAL)')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'niR'?'%#'..get(g:tene_hi,'n','Visual')..'#\ '..(g:tene_mode==1?'niR\ ':get(g:tene_modes,'niR','REPLACE\ (NORMAL)')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'niV'?'%#'..get(g:tene_hi,'n','Visual')..'#\ '..(g:tene_mode==1?'niV\ ':get(g:tene_modes,'niV','VIRTUAL\ REPLACE\ (NORMAL)')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'nt'?'%#'..get(g:tene_hi,'n','Visual')..'#\ '..(g:tene_mode==1?'nt\ ':get(g:tene_modes,'nt','TERMINAL\ (NORMAL)')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'v'?'%#'..get(g:tene_hi,'v','DiffAdd')..'#\ '..(g:tene_mode==1?'v\ ':get(g:tene_modes,'v','VISUAL')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'vs'?'%#'..get(g:tene_hi,'v','DiffAdd')..'#\ '..(g:tene_mode==1?'vs\ ':get(g:tene_modes,'vs','SELECT\ (VISUAL)')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'V'?'%#'..get(g:tene_hi,'v','DiffAdd')..'#\ '..(g:tene_mode==1?'V\ ':get(g:tene_modes,'V','VISUAL\ LINE')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'Vs'?'%#'..get(g:tene_hi,'v','DiffAdd')..'#\ '..(g:tene_mode==1?'Vs\ ':get(g:tene_modes,'Vs','SELECT\ (VISUAL\ LINE)')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#''?'%#'..get(g:tene_hi,'v','DiffAdd')..'#\ '..(g:tene_mode==1?'^V\ ':get(g:tene_modes,'CTRL-V','VISUAL\ BLOCK')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'s'?'%#'..get(g:tene_hi,'v','DiffAdd')..'#\ '..(g:tene_mode==1?'^Vs\ ':get(g:tene_modes,'CTRL-Vs','SELECT\ (VISUAL\ BLOCK)')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'s'?'%#'..get(g:tene_hi,'v','DiffAdd')..'#\ '..(g:tene_mode==1?'s\ ':get(g:tene_modes,'s','SELECT')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'S'?'%#'..get(g:tene_hi,'v','DiffAdd')..'#\ '..(g:tene_mode==1?'S\ ':get(g:tene_modes,'S','SELECT\ LINE')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#''?'%#'..get(g:tene_hi,'v','DiffAdd')..'#\ '..(g:tene_mode==1?'^S\ ':get(g:tene_modes,'CTRL-S','SELECT\ BLOCK')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()?(mode(1)==#'i'&&state()!=#'S'&&&iminsert!=1?'%#'..get(g:tene_hi,'i','WildMenu')..'#\ '..(g:tene_mode==1?'i\ ':get(g:tene_modes,'i','INSERT')..'\ '):''):''%}
set statusline+=%{%g:actual_curwin==win_getid()?(mode(1)==#'i'&&state()!=#'S'&&&iminsert==1?'%#'..get(g:tene_hi,'i','WildMenu')..'#\ '..(g:tene_mode==1?'i\ ':get(g:tene_modes,'i','INSERT')..'\ ')..(g:tene_keymap==1?'%k\ ':''):''):''%}
set statusline+=%{%g:actual_curwin==win_getid()?(mode(1)==#'i'&&state()==#'S'?'%#'..get(g:tene_hi,'o','ErrorMsg')..'#'..g:tene_state_S..'%#'..get(g:tene_hi,'i','WildMenu')..'#\ '..(g:tene_mode==1?'i\ ':get(g:tene_modes,'i','INSERT')..'\ '):''):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'ic'?'%#'..get(g:tene_hi,'i','WildMenu')..'#\ '..(g:tene_mode==1?'ic\ ':get(g:tene_modes,'i','INSERT\ COMPLETION\ C')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'ix'?'%#'..get(g:tene_hi,'i','WildMenu')..'#\ '..(g:tene_mode==1?'ix\ ':get(g:tene_modes,'i','INSERT\ COMPLETION\ X')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()?(mode(1)==#'R'&&state()!=#'S'&&&iminsert!=1?'%#'..get(g:tene_hi,'r','Pmenu')..'#\ '..(g:tene_mode==1?'R\ ':get(g:tene_modes,'R','REPLACE')..'\ '):''):''%}
set statusline+=%{%g:actual_curwin==win_getid()?(mode(1)==#'R'&&state()!=#'S'&&&iminsert==1?'%#'..get(g:tene_hi,'r','Pmenu')..'#\ '..(g:tene_mode==1?'R\ ':get(g:tene_modes,'R','REPLACE')..'\ ')..(g:tene_keymap==1?'%k\ ':''):''):''%}
set statusline+=%{%g:actual_curwin==win_getid()?(mode(1)==#'R'&&state()==#'S'?'%#'..get(g:tene_hi,'o','ErrorMsg')..'#'..g:tene_state_S..'%#'..get(g:tene_hi,'r','Pmenu')..'#\ '..(g:tene_mode==1?'R\ ':get(g:tene_modes,'R','REPLACE')..'\ '):''):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'Rc'?'%#'..get(g:tene_hi,'r','Pmenu')..'#\ '..(g:tene_mode==1?'Rc\ ':get(g:tene_modes,'Rc','REPLACE\ COMPLETION\ C')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'Rx'?'%#'..get(g:tene_hi,'r','Pmenu')..'#\ '..(g:tene_mode==1?'Rx\ ':get(g:tene_modes,'Rc','REPLACE\ COMPLETION\ X')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()?(mode(1)==#'Rv'&&state()!=#'S'&&&iminsert!=1?'%#'..get(g:tene_hi,'r','Pmenu')..'#\ '..(g:tene_mode==1?'Rv\ ':get(g:tene_modes,'Rv','VIRTUAL\ REPLACE')..'\ '):''):''%}
set statusline+=%{%g:actual_curwin==win_getid()?(mode(1)==#'Rv'&&state()!=#'S'&&&iminsert==1?'%#'..get(g:tene_hi,'r','Pmenu')..'#\ '..(g:tene_mode==1?'Rv\ ':get(g:tene_modes,'Rv','VIRTUAL\ REPLACE')..'\ ')..(g:tene_keymap==1?'%k\ ':''):''):''%}
set statusline+=%{%g:actual_curwin==win_getid()?(mode(1)==#'Rv'&&state()==#'S'?'%#'..get(g:tene_hi,'o','ErrorMsg')..'#'..g:tene_state_S..'%#'..get(g:tene_hi,'r','Pmenu')..'#\ '..(g:tene_mode==1?'Rv\ ':get(g:tene_modes,'Rv','VIRTUAL\ REPLACE')..'\ '):''):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'Rvc'?'%#'..get(g:tene_hi,'r','Pmenu')..'#\ '..(g:tene_mode==1?'Rvc\ ':get(g:tene_modes,'Rvc','VIRTUAL\ REPLACE\ COMPLETION\ C')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'Rvx'?'%#'..get(g:tene_hi,'r','Pmenu')..'#\ '..(g:tene_mode==1?'Rvx\ ':get(g:tene_modes,'Rvx','VIRTUAL\ REPLACE\ COMPLETION\ X')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'c'&&&iminsert!=1?'%#'..get(g:tene_hi,'c','StatusLineTermNC')..'#\ '..(g:tene_mode==1?'c\ ':get(g:tene_modes,'c','COMMAND-LINE')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'c'&&&iminsert==1?'%#'..get(g:tene_hi,'c','StatusLineTermNC')..'#\ '..(g:tene_mode==1?'c\ ':get(g:tene_modes,'c','COMMAND-LINE')..'\ ')..(g:tene_keymap==1?'%k\ ':''):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'cv'?'%#'..get(g:tene_hi,'c','StatusLineTermNC')..'#\ '..(g:tene_mode==1?'cv\ ':get(g:tene_modes,'cv','VIM\ EX')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'ce'?'%#'..get(g:tene_hi,'c','StatusLineTermNC')..'#\ '..(g:tene_mode==1?'ce\ ':get(g:tene_modes,'ce','EX')..'\ '):''%}
set statusline+=%{%g:actual_curwin==win_getid()&&mode(1)==#'t'?'%#'..get(g:tene_hi,'c','StatusLineTermNC')..'#\ '..(g:tene_mode==1?'t\ ':get(g:tene_modes,'t','TERMINAL-JOB')):''%}
# Highlight the rest of the active/current window's statusline.
set statusline+=%{%g:actual_curwin==win_getid()?('%#'..((mode(1)==#'t'\|\|mode(1)==#'nt')?get(g:tene_hi,'t','StatusLineTerm'):get(g:tene_hi,'s','StatusLine'))..'#'):''%}
# Highlight the rest of the inactive/non-current windows' statuslines.
set statusline+=%{%g:actual_curwin==win_getid()?'':'%#'..((mode(1)==#'t'\|\|mode(1)==#'nt')?get(g:tene_hi,'c','StatusLineTermNC'):get(g:tene_hi,'x','StatusLineNC'))..'#'%}
# Display help indicator in help windows.
set statusline+=%{&buftype=='help'?'\ '..(g:tene_glyphs==1?(g:tene_ga['buftypehelp'][1]):(g:tene_ga['buftypehelp'][0])):''}
set statusline+=\ 
# The buffer number of the buffer in each window - optional.
# This could have a total buffers option added with set statusline+=\ %(%{'b'.bufnr('%')}/%{len(getbufinfo())}\ %)
# but testing showed it was very distracting because the buffers are created and wiped not only by the user, so the number moves around a lot.
set statusline+=%{g:tene_buffer_num==1?(g:tene_glyphs==1?(g:tene_ga['bufnr'][1]):(g:tene_ga['bufnr'][0]))..bufnr()..'\ ':''}
# Provide the current window number
set statusline+=%{g:tene_window_num==1?(g:tene_glyphs==1?(g:tene_ga['winnr'][1]):(g:tene_ga['winnr'][0]))..winnr()..'\ ':''}
## Truncate the statusline here.
set statusline+=%<
# A paste indicator &paste is on.  :h 'paste'
set statusline+=%{!&readonly&&&paste!=0?(g:tene_glyphs==1?(g:tene_ga['paste'][1])..'\ ':(g:tene_ga['paste'][0])..'\ '):''}
# Modified flag (but only display it where the buftype is not 'terminal' because there is no point showing that since it's immediately modified)
set statusline+=%{&modified&&&buftype!='terminal'?(g:tene_glyphs==1?(g:tene_ga['mod'][1])..'\ ':(g:tene_ga['mod'][0])..'\ '):''}
# Modifiable flag (similar to Modified but also show not modifiable in Terminal-Normal mode, so 't', not the buftype, which includes Terminal-Job).
set statusline+=%{(!&modifiable&&mode()!=#'t')?(g:tene_glyphs==1?(g:tene_ga['noma'][1])..'\ ':(g:tene_ga['noma'][0])..'\ '):''}
# Display Preview indicator in Preview windows.
set statusline+=%{&previewwindow==1?(g:tene_glyphs==1?(g:tene_ga['pvw'][1])..'\ ':(g:tene_ga['pvw'][0])..'\ '):''}
# Display digraph indicator when digraph is enabled.
set statusline+=%{!&readonly&&&digraph!=0&&(mode(1)==#'cv'\|\|mode(1)==#'c'\|\|mode(1)==#'i'\|\|mode(1)==#'Rv'\|\|mode(1)==#'R')?(g:tene_glyphs==1?(g:tene_ga['dg'][1])..'\ ':(g:tene_ga['dg'][0])..'\ '):''}
# Display a key indicator when key option is on: i.e., the buffer is encrypted.
set statusline+=%{&key!=''?((g:tene_glyphs==1?(g:tene_ga['key'][1]):(g:tene_ga['key'][0]))..(&cryptmethod!='blowfish2'?'('..&cryptmethod..')':'').'\ '):''}
# Display a spell indicator when spell checking option is on.
set statusline+=%{!&readonly&&&spell!=0?(g:tene_glyphs==1?(g:tene_ga['spell'][1])..'\ ':(g:tene_ga['spell'][0])..'\ '):''}
# Display a macro recording indicator when a macro is being recorded.
set statusline+=%{reg_recording()==''?'':(g:tene_glyphs==1?(g:tene_ga['recording'][1]):(g:tene_ga['recording'][0]))..reg_recording()..'\ '}
# The filename.  Just 'tail' if that option is chosen, noting items %f and %t
# show as '[No Name]' for the initial buffer - using expand('%:t') prevents that.
set statusline+=%{%g:tene_file_tail==1&&&filetype!='netrw'?expand('%:t')..'\ ':(&filetype!='netrw'?(g:tene_path==0?'%f\ ':'%F\ '):'')%}
# Read only flag.
set statusline+=%{&readonly?(g:tene_glyphs==1?(g:tene_ga['ro'][1]):(g:tene_ga['ro'][0])):''}
# Separation point between left and right aligned items.
set statusline+=%=
# Where the window isn't a terminal, the file type and a space, otherwise nil.
set statusline+=%{&buftype!='terminal'?&filetype..(&filetype==''?'':'\ '):''}
# File encoding, including the byte order mark (when applicable), and a space.
set statusline+=%{(&fileencoding==''?&encoding:&fileencoding)..(&bomb?'[BOM]':'')..'\ '}
# File format.  Display nothing if no file type.
set statusline+=%{&filetype!=''?&fileformat..'\ ':''}
# Percent through the buffer, which is not so useful if you have line numbers
# (current/total).  And not in Terminal.  Other ways to do this could be:
#   set statusline+=%{(...)?(line('.')*100/line('$')..'%\ '):''}
# which would show the percentage (and not Top/Bot), not needing %{% and %} or
#   set statusline+=%{%(...)?'%p%%\ ':''%}
#   which uses the other default percentage option, %p, but needs %{% and %}
# So, rather than even more options for this, just %P if g:tene_percent is on.
# NB: mode() is used here since that is the same as mode(0), i.e., only
#     the first letter of the mode.  Terminal-Normal mode, nt, should have all
#     of the features available (which make no sense in Terminal-Job mode).
set statusline+=%{%(mode()!=#'t'&&g:tene_percent==1)?'%P\ ':''%}
# Line number and line numbers; line('.') is %l and line('$') is %L.
set statusline+=%{mode()!=#'t'?(g:tene_line_num==1?(g:tene_glyphs==1?(g:tene_ga['line()'][1]):(g:tene_ga['line()'][0]))..line('.'):''):''}
set statusline+=%{mode()!=#'t'?(g:tene_line_num==1&&g:tene_line_nums==1?'/'..line('$'):''):''}
set statusline+=%{mode()!=#'t'?(g:tene_line_num==1?'\ ':''):''}
# The virtual column, virtcol('.'), which differs from either %v or %V.
set statusline+=%{(mode()!=#'t'&&g:tene_virtcol==1)?(g:tene_glyphs==1?(g:tene_ga['virtcol()'][1]):(g:tene_ga['virtcol()'][0]))..virtcol('.'):''}
set statusline+=%{(mode()!=#'t'&&g:tene_virtcol==1)?'\ ':''}
# Byte column, which is less desirable in a lot of use cases because it
# will return apparently odd column numbers where there are multi-byte
# characters in the line.  Plus, with <Tab> widths being variable ....
# The virtual column %V, which partners with %c insofar as it displays
# -{num}, but not at all if %V is equal to %c, is also included.
set statusline+=%{(mode()!=#'t'&&g:tene_col==1)?(g:tene_glyphs==1?(g:tene_ga['col()'][1]):(g:tene_ga['col()'][0])):''}
set statusline+=%{%(mode()!=#'t'&&g:tene_col==1)?'%c%V\ ':''%}
# Unicode information, e.g. ¢ is U+00A2.  Zeros are omitted to save space.
set statusline+=%{%mode()!=#'t'&&g:tene_unicode==1?'U+%B':''%}
# Handling composing characters too like नि (U+928,U+93F) and Ä (U+41,U+308).
set statusline+=%{mode()!=#'t'&&g:tene_unicode==1&&byteidxcomp(matchstr(getline('.')[col('.')-1:-1],'.'),2)!=-1?',U+'..printf('%X',strgetchar(matchstr(getline('.')[col('.')-1:-1],'.'),1)):''}
set statusline+=%{mode()!=#'t'&&g:tene_unicode==1&&byteidxcomp(matchstr(getline('.')[col('.')-1:-1],'.'),3)!=-1?',U+'..printf('%X',strgetchar(matchstr(getline('.')[col('.')-1:-1],'.'),2)):''}
set statusline+=%{mode()!=#'t'&&g:tene_unicode==1?'\ ':''}
# Highlight group of the character under the cursor.
set statusline+=%{g:tene_hl_group==1?synIDattr(synID(line("."),col("."),1),"name"):''}
set statusline+=%{g:tene_hl_group==1&&len(synIDattr(synID(line("."),col("."),1),"name"))>1?'\ ':''}
# Mode and state indicators.  Precision provided by this is great for debugging.
set statusline+=%{g:tene_modestate==1?mode(1)..'\ '..(state()!=''?state()..'\ ':''):''}
# }}}
# <Plug> mappings for toggling variables {{{
# These map commands establish the mappings (Normal, Visual, Select,
# Operator-pending modes) for 14 'Tene-{char}' toggles
map <Plug>Tene% <Cmd>execute "let g:tene_percent = (g:tene_percent == 1) ? 0 : 1"<CR>
map <Plug>TeneB <Cmd>execute "let g:tene_buffer_num = (g:tene_buffer_num == 1) ? 0 : 1"<CR>
map <Plug>TeneC <Cmd>execute "let g:tene_col = (g:tene_col == 1) ? 0 : 1"<CR>
map <Plug>TeneF <Cmd>execute "let g:tene_file_tail = (g:tene_file_tail == 1) ? 0 : 1"<CR>
map <Plug>TeneG <Cmd>execute "let g:tene_glyphs = (g:tene_glyphs == 1) ? 0 : 1"<CR>
map <Plug>TeneH <Cmd>execute "let g:tene_hl_group = (g:tene_hl_group == 1) ? 0 : 1"<CR>
map <Plug>TeneK <Cmd>execute "let g:tene_keymap = (g:tene_keymap == 1) ? 0 : 1"<CR>
map <Plug>TeneL <Cmd>execute "let g:tene_line_num = (g:tene_line_num == 1) ? 0 : 1"<CR>
map <Plug>TeneM <Cmd>execute "let g:tene_mode = (g:tene_mode == 1) ? 0 : 1"<CR>
map <Plug>TeneS <Cmd>execute "let g:tene_modestate = (g:tene_modestate == 1) ? 0 : 1"<CR>
map <Plug>TeneP <Cmd>execute "let g:tene_path = (g:tene_path == 1) ? 0 : 1"<CR>
map <Plug>TeneU <Cmd>execute "let g:tene_unicode = (g:tene_unicode == 1) ? 0 : 1"<CR>
map <Plug>TeneV <Cmd>execute "let g:tene_virtcol = (g:tene_virtcol == 1) ? 0 : 1"<CR>
map <Plug>TeneW <Cmd>execute "let g:tene_window_num = (g:tene_window_num == 1) ? 0 : 1"<CR>
map <Plug>TeneZ <Cmd>execute "let g:tene_line_nums = (g:tene_line_nums == 1) ? 0 : 1"<CR>
# }}}
# <Leader> key map (nvo) mappings {{{
# 1. These  are set only if the user has not either already mapped the
#    applicable <Plug> mapping or the applicable mapping already exists.
# 2. The use of 'map' means the mappings work in Normal, Visual, Select,
#    and Operator Pending modes.  Applying to Select mode is not necessarily
#    ideal, especially if the user's <Leader> is <Space> because there
#    will be a delay before the following character is typed rather than
#    being interpreted as the literal character immediately, but that is
#    better than nmap in this instance because the mappings are useful in
#    not just Normal mode, so a slight delay in Select mode, which by
#    most accounts few users use, is an acceptable downside.  And it is
#    easy to override these anyway, as outlined in 1, above.
execute (!hasmapto('<Plug>Tene%') && maparg('<Leader>t%', '') == '') ? ':map <Leader>t% <Plug>Tene%' : ''
execute (!hasmapto('<Plug>TeneB') && maparg('<Leader>tb', '') == '') ? ':map <Leader>tb <Plug>TeneB' : ''
execute (!hasmapto('<Plug>TeneC') && maparg('<Leader>tc', '') == '') ? ':map <Leader>tc <Plug>TeneC' : ''
execute (!hasmapto('<Plug>TeneF') && maparg('<Leader>tf', '') == '') ? ':map <Leader>tf <Plug>TeneF' : ''
execute (!hasmapto('<Plug>TeneG') && maparg('<Leader>tg', '') == '') ? ':map <Leader>tg <Plug>TeneG' : ''
execute (!hasmapto('<Plug>TeneH') && maparg('<Leader>th', '') == '') ? ':map <Leader>th <Plug>TeneH' : ''
execute (!hasmapto('<Plug>TeneK') && maparg('<Leader>tk', '') == '') ? ':map <Leader>tk <Plug>TeneK' : ''
execute (!hasmapto('<Plug>TeneL') && maparg('<Leader>tl', '') == '') ? ':map <Leader>tl <Plug>TeneL' : ''
execute (!hasmapto('<Plug>TeneM') && maparg('<Leader>tm', '') == '') ? ':map <Leader>tm <Plug>TeneM' : ''
execute (!hasmapto('<Plug>TeneP') && maparg('<Leader>tp', '') == '') ? ':map <Leader>tp <Plug>TeneP' : ''
execute (!hasmapto('<Plug>TeneS') && maparg('<Leader>ts', '') == '') ? ':map <Leader>ts <Plug>TeneS' : ''
execute (!hasmapto('<Plug>TeneU') && maparg('<Leader>tu', '') == '') ? ':map <Leader>tu <Plug>TeneU' : ''
execute (!hasmapto('<Plug>TeneV') && maparg('<Leader>tv', '') == '') ? ':map <Leader>tv <Plug>TeneV' : ''
execute (!hasmapto('<Plug>TeneW') && maparg('<Leader>tw', '') == '') ? ':map <Leader>tw <Plug>TeneW' : ''
execute (!hasmapto('<Plug>TeneZ') && maparg('<Leader>tz', '') == '') ? ':map <Leader>tz <Plug>TeneZ' : ''
# }}}
# Licence {{{
# BSD 3-Clause License
# https://github.com/kennypete/vim-tene/blob/main/LICENCE
# Copyright © 2023 Peter Kenny }}}
# vim: filetype=vim foldmethod=marker nowrap
