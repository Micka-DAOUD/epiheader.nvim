
-- header_template_commands.lua


local M = {}

local commentSymbols = {
    cpp = { "/*", "**", "*/" },
    hpp = { "/*", "**", "*/" },
    c = { "/*", "**", "*/" },
    h = { "/*", "**", "*/" },
    haskell = { "{-", "--", "-}" },
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
        vim.cmd("redraw!")
        if fileDesc == "" then
            fileDesc = filename
        end

        vim.fn.append(0, commentSymbols[extension][1]);
        vim.fn.append(1, commentSymbols[extension][2] .. " EPITECH PROJECT, " .. date)
        vim.fn.append(2, commentSymbols[extension][2] .. " Created by " .. user)
        vim.fn.append(3, commentSymbols[extension][2] .. " File description:")
        vim.fn.append(4, commentSymbols[extension][2] .. " " .. fileDesc)
        vim.fn.append(5, commentSymbols[extension][3])
        vim.fn.append(6, "")

        local bufname = vim.fn.bufname()
        if extension == 'cpp' and (vim.fn.match(bufname, ".hpp$") > 0 or vim.fn.match(bufname, ".h$") > 0) then
            local include_guard = string.upper(string.gsub(filename, "%.", "_")) .. "_"

            vim.fn.append(7, "#ifndef " .. include_guard)
            vim.fn.append(8, "\t#define " .. include_guard)

            if vim.fn.match(bufname, ".hpp$") > 0 then
                local rawFilename = vim.fn.fnamemodify(vim.fn.bufname(), ':t:r')
                local addClass = vim.fn.input("Create class " .. rawFilename .. "? (Y/n)")
                vim.cmd("redraw!")
                if (addClass ~= "n" and addClass ~= "N" and addClass ~= "no" and addClass ~= "NO") then
                    vim.fn.append(9, "")
                    vim.fn.append(10, "class " .. rawFilename .. " {")
                    vim.fn.append(11, "\tprivate:")
                    vim.fn.append(12, "\tpublic:")
                    vim.fn.append(13, "\t\t" .. rawFilename .. "();")
                    vim.fn.append(14, "\t\t" .. "~" .. rawFilename .. "();")
                    vim.fn.append(15, "};")
                end
            end

            local totalLines = vim.fn.line("$")
            vim.fn.append(totalLines, "#endif /* !" .. include_guard .. " */")
        end
        vim.print("Successfully generated " .. filename .. " header.")
    else
        error("Unknown extension: " .. extension)
    end
end

return M
