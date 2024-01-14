if exists("g:loaded_epiheader")
    finish
endif

let g:loaded_epiheader = 1

exe "lua package.path = package.path .. ';" . "/lua-?/init.lua'"

command!  -nargs=0 TekHeader lua require("epiheader").insert_header()
