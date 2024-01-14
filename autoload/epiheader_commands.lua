
-- header_template_commands.lua

local M = {}

local commentSymbols = {
    cpp = { "/*", "**", "*/" },
    hpp = { "/*", "**", "*/" },
    c = { "/*", "**", "*/" },
    h = { "/*", "**", "*/" },
    hs = { "{-", "--", "-}" },
}

function M.insert_header()
    -- Get the current buffer number
    local bufnr = vim.fn.bufnr()
    local extension = vim.fn.getbufvar(bufnr, '&filetype')
    local filename = vim.fn.fnamemodify(vim.fn.bufname(), ':t')
    local date = os.date("%Y")
    local user = os.getenv("USER") or "myself"

    if commentSymbols[extension] then
        local fileDesc = vim.fn.input("File description: ")
        if fileDesc == "" then
            fileDesc = filename
        end

        vim.fn.append(0, commentSymbols[extension][0]);
        vim.fn.append(1, commentSymbols[extension][1] .. " EPITECH PROJECT, " .. date)
        vim.fn.append(2, commentSymbols[extension][1] .. " Created by " .. user)
        vim.fn.append(3, commentSymbols[extension][1] .. " File description:")
        vim.fn.append(4, commentSymbols[extension][1] .. " " .. fileDesc)
        vim.fn.append(5, commentSymbols[extension][2])
        vim.fn.append(6, "")

        if extension == "hpp" or extension == "h" then
            local totalLines = vim.fn.line("$")
            local rawFilename = vim.fn.fnamemodify(vim.fn.bufname(), ':t')
            local include_guard = string.upper(rawFilename)
            vim.fn.append(7, "#ifndef " .. include_guard)
            vim.fn.append(8, "    #define " .. include_guard)
            vim.fn.append(totalLines, "#endif /* !" .. include_guard .. " */")
        end
    end
end

return M
