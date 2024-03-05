
-- header_template_commands.lua


local M = {}

local commentSymbols = {
    cpp = { "/*", "**", "*/" },
    hpp = { "/*", "**", "*/" },
    c = { "/*", "**", "*/" },
    h = { "/*", "**", "*/" },
    hs = { "{-", "--", "-}" },
    haskell = { "{-", "--", "-}" },
    make = { "##", "##", "##" },
}

local function getHeaderComment(extensionComment, fileDescription)
    local date = os.date("%Y")
    local user = os.getenv("USER") or "myself"
    return {
        extensionComment[1],
        extensionComment[2] .. " EPITECH PROJECT, " .. date,
        extensionComment[2] .. " Created by " .. user,
        extensionComment[2] .. " File description:",
        extensionComment[2] .. " " .. fileDescription,
        extensionComment[3],
    }
end

local function getTextToAdd(extension, fileDescription)
    local bufname = vim.fn.bufname()
    local filename = vim.fn.fnamemodify(bufname, ':t')
    local include_guard = string.upper(string.gsub(filename, "%.", "_")) .. "_"
    local header = getHeaderComment(commentSymbols[extension], fileDescription)
    table.insert(header, "")

    if extension == 'cpp' and (vim.fn.match(bufname, ".hpp$") > 0 or vim.fn.match(bufname, ".h$") > 0) then
        if vim.fn.match(bufname, ".h$") then
            table.insert(header, "#ifndef " .. include_guard)
            table.insert(header, "\t#define " .. include_guard)
            table.insert(header, "")
        else
            table.insert(header, "#pragma once")
            table.insert(header, "")

            local rawFilename = vim.fn.fnamemodify(vim.fn.bufname(), ':t:r')
            local addClass = vim.fn.input("Create class " .. rawFilename .. "? (Y/n)")
            vim.cmd("redraw!")

            if (addClass ~= "n" and addClass ~= "N" and addClass ~= "no" and addClass ~= "NO") then
                table.insert(header, "class" .. rawFilename .. " {")
                table.insert(header, "public:")
                table.insert(header, "\t" .. rawFilename .. "();")
                table.insert(header, "\t~" .. rawFilename .. "() = deffault;")
                table.insert(header, "};")
            end
        end
    end
    return header
end


function M.insertHeader()
    -- Get the current buffer number
    local extension = vim.fn.getbufvar(vim.fn.bufnr(), '&filetype')
    local filename = vim.fn.fnamemodify(vim.fn.bufname(), ':t')

    if not commentSymbols[extension] then
        error("Unknown extension: " .. extension)
        return
    end

    local fileDescription = vim.fn.input("File description: ")
    vim.cmd("redraw!")
    if fileDescription == "" then
        fileDescription = filename
    end

    local textToAdd = getTextToAdd(extension, fileDescription)

    for i, line in ipairs(textToAdd) do
        vim.fn.append(i - 1, line)
    end

    local bufname = vim.fn.bufname()
    if extension == 'cpp' and vim.fn.match(bufname, ".h$") > 0 then
        local include_guard = string.upper(string.gsub(filename, "%.", "_")) .. "_"
        local totalLines = vim.fn.line("$")
        vim.fn.append(totalLines, "#endif /* !" .. include_guard .. " */")
    end
    vim.print("Successfully generated " .. filename .. " header.")
end

return M
