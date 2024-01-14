if exists("g:loaded_epiheader")
    finish
endif

let g:loaded_epiheader = 1

exe "lua package.path = package.path .. ';" . "/lua-?/init.lua'"

nnoremap <silent> <leader>H :lua require("epiheader").insert_header()<CR>
command!  -nargs=0 TekHeader lua require("epiheader").insert_header()
