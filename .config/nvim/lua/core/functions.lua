local au = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup

-- alias 'filetype detect'
vim.api.nvim_create_user_command("FTD", "filetype detect", {})

-- trim trailing whitespace on write
local group = ag("FormatOnSave", { clear = true })
local fmt_actions = {
    {
        callback = function()
            local cursor = vim.fn.getpos(".")
            vim.cmd([[%s/\s\+$//e]])
            vim.fn.setpos(".", cursor)
        end,
        desc = "Trim trailing whitespace",
    },
    {
        callback = function()
            vim.lsp.buf.format()
        end,
        desc = "Apply LSP Formatting",
    }
}

for _, action in pairs(fmt_actions) do
    au({ "BufWritePre" }, {
        pattern = { "*" },
        group = group,
        callback = action.callback,
        desc = action.desc,
    })
end

-- Force-set filetype
group = ag("FileTypeAdjustments", { clear = true })
local filetypes = {
    ["groff"] = { "*.ms", "*.me", "*.mom", "*.man" },
    ["tex"] = { "*.tex" },
    ["sh"] = { "*.sh", "*.bash" },
}

for ft, pattern in pairs(filetypes) do
    au({ "BufRead", "BufNewFile" }, {
        pattern = pattern,
        group = group,
        command = "set filetype=" .. ft,
        desc = "Set filetype to '" .. ft .. "'",
    })
end

-- Support comments in json
au({ "FileType" }, {
    pattern = { "json" },
    group = ag("CustomCommentSupport", { clear = true }),
    command = [[syntax match Comment +\/\/.\+$++]],
    desc = "Add comment support to JSON",
})

-- Native templates
group = ag("TemplateFiles", { clear = true })
local templates = {
    ["sh"] = { "*.sh", "*.bash" },
    ["bat"] = { "*.bat", "*.cmd" },
    ["ahk"] = { "*.ahk" },
    ["ps1"] = { "*.ps1", "*.psm1" },
}
for ext, pattern in pairs(templates) do
    au({ "BufNewFile" }, {
        pattern = pattern,
        group = group,
        command = "0r ~/.config/templates/template." .. ext,
        desc = "Load template for '" .. ext .. "'",
    })
end
