" Vim filetype plugin file
" Language:	GISDK
" Maintainer:	Luis Eduardo Ximenes Carvalho <lexcarvalho@hotmail.com>
" Last Change:	2002 Apr 27

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

" Don't load another plugin for this buffer
let b:did_ftplugin = 1

set cpt=k
set dict=$VIMRUNTIME/ftplugin/gisdk.dict
an 40.320 &Tools.Build\ &Tags\ File		:!ctags -c "/^\(macro\\|dbox\)[ \t]*\"\([a-zA-Z0-9_]*\)\"/\2/" %<CR>
