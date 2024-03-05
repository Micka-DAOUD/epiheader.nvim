if exists("g:loaded_epiheader")
    finish
endif

let g:loaded_epiheader = 1

exe "lua package.path = package.path .. ';" . "/lua-?/init.lua'"

nnoremap <silent> <leader>H :lua require("epiheader").insertHeader()<CR>
command!  -nargs=0 TekHeader lua require("epiheader").insertHeader()
