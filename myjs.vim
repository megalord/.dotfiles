" comments
syn match   jsComment      /\/\/.*/
syn region  jsComment      start=/\/\*/ end=/\*\//

hi def link jsComment      Comment

syntax match jsNumber      /\d/

hi def link jsNumber       Number

" Program Keywords
syntax keyword jsIdentifier arguments this let void yield
syntax keyword jsOperator  delete new instanceof typeof
syntax keyword jsBoolean   true false
syntax keyword jsNull      null undefined
syntax keyword jsMessage   alert confirm prompt status

hi def link jsIdentifier   Identifier
hi def link jsOperator     Operator
hi def link jsBoolean      Boolean
hi def link jsNull         Type
hi def link jsMessage      Keyword

" Statement Keywords
syntax keyword jsConditional if else switch
syntax keyword jsLoop      do while for in
syntax keyword jsBranch    break continue
syntax keyword jsLabel     case default
syntax keyword jsStatement return with

hi def link jsConditional  Conditional
hi def link jsLoop         Repeat
hi def link jsBranch       Conditional
hi def link jsLabel        Label
hi def link jsStatement    Statement

" function definitions
syn keyword jsFunction     function nextgroup=jsFuncName,jsArgBlock skipwhite
syn match   jsFuncName     /\w\+/ nextgroup=jsArgBlock contained
syn region  jsArgBlock     start=/(/ end=/)/ contains=jsFuncArg contained
syn match   jsFuncArg      /\w\+/ contained

hi def link jsFunction     Type
hi def link jsFuncName     Function
hi def link jsFuncArg      Identifier

" variable definitions
syn keyword jsVar          var nextgroup=jsVarName skipwhite
syn match   jsVarDef       /,\n*\s*\w\+\s*[,=]/ contains=jsVarDef,jsVarName,jsEqual
syn match   jsVarName      /\w\+/ contained

hi def link jsVar          Type
hi def link jsVarName      Function

" symbols
syn match   jsEqual        /[=!]/

hi def link jsEqual        Statement

" strings
syn region  jsString       start=/"/ skip=/\\"/ end=/"/
syn region  jsString       start=/'/ skip=/\\'/ end=/'/

hi def link jsString       String
