" autoload/epitech.vim
"
" dictionary of the comments styles for supported languages
" 1: first line
" 2: middle lines
" 3: last line
let s:comStyles = {
			\'make': {'1': '##', '2': '##', '3': '##'},
      \'haskell': {'1': '{-', '2': '--', '3': '-}'},
			\'c': {'1': '/*', '2': '**', '3': '*/'},
			\'cpp': {'1': '/*', '2': '**', '3': '*/'},
			\'python': {'1': '#!/usr/bin/env python3\n##', '2': '##', '3': '##'},
			\}

" check if current filetype is supported
function! s:CheckFiletype()
	" check dictionary for current filetype
	return has_key(s:comStyles, &filetype)
endfunction

" function to get current year
function! s:GetCurrentYear()
	let currentYear = strftime("%Y")
	return currentYear
endfunction

" function to prompt user for file description
function! s:InputFileDescription()
	" call inputsave() to prompt user for input
	" call inputrestore() to finish user prompt

	call inputsave()
	let file_description = input('Enter file description: ')
	call inputrestore()
	" if the length of the input is null
	if strlen(file_description) == 0
		let currentSecond = strftime('%S') / 2
		let file_description = " Epitech project file"
	endif
	return file_description
endfunction

" function to insert the epitech header
function epitech#addHeader()
	" if checkFiletype() fails, return error
	if !s:CheckFiletype()
		echoerr "Unsupported filetype for Epitech header: " . &filetype
		return
	endif

	let l:com1 = s:comStyles[&filetype]['1']
	let l:com2 = s:comStyles[&filetype]['2']
	let l:com3 = s:comStyles[&filetype]['3']

	let l:let = append(0, l:com1)
	let l:let = append(1, l:com2 . " EPITECH PROJECT, " . s:GetCurrentYear())
	let l:let = append(2, l:com2 . " Created by Micka DAOUD" )
	let l:let = append(3, l:com2 . " File description:")
	let l:let = append(4, l:com2 . s:InputFileDescription())
	let l:let = append(5, l:com3)
	let l:let = append(6, "")
	:8
endfunction