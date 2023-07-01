local cmd = vim.api.nvim_create_user_command
local au = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup

-- alias 'filetype detect'
cmd("FTD", "filetype detect", {})

-- trim trailing whitespace on write
local group = ag("FormatOnSave", { clear = true })
au("BufWritePre", {
    pattern = { "*" },
    group = group,
    callback = function()
        local pos = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", pos)
    end,
})

-- LSP Format on save, if available
au({ "BufWritePre" }, {
    pattern = { "*" },
    group = group,
    callback = function() vim.lsp.buf.format() end,
})

-- Force-set filetype
local group = ag("FileTypeAdjustments", { clear = true })
au({ "BufRead", "BufNewFile" }, {
    pattern = { "/tmp/calcurse*", "~/.calcurse/notes/*" },
    group = group,
    command = "set filetype=markdown",
})
au({ "BufRead", "BufNewFile" }, {
    pattern = { "*.ms", "*.me", "*.mom", "*.man" },
    group = group,
    command = "set filetype=groff",
})
au({ "BufRead", "BufNewFile" }, {
    pattern = { "*.tex" },
    group = group,
    command = "set filetype=tex",
})
au({ "BufRead", "BufNewFile" }, {
    pattern = { "*.sh", "*.bash" },
    group = group,
    command = "set filetype=sh",
})

-- Support comments in json
au({ "FileType" }, {
    pattern = { "json" },
    group = ag("CustomCommentSupport", { clear = true }),
    command = [[syntax match Comment +\/\/.\+$++]],
})

-- Native templates
local group = ag("TemplateFiles", { clear = true })
local template = "~/.config/templates/template"
au({ "BufNewFile" }, {
    pattern = { "*.sh", "*.bash" },
    group = group,
    command = "0r " .. template .. ".sh",
})
au({ "BufNewFile" }, {
    pattern = { "*.bat", "*.cmd" },
    group = group,
    command = "0r " .. template .. ".bat",
})
au({ "BufNewFile" }, {
    pattern = { "*.ahk" },
    group = group,
    command = "0r " .. template .. ".ahk",
})
au({ "BufNewFile" }, {
    pattern = { "*.ps1" },
    group = group,
    command = "0r " .. template .. ".ps1",
})
