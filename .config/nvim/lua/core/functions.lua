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
vim.filetype.add({
    extension = {
        ms = 'groff',
        me = 'groff',
        mom = 'groff',
        man = 'groff',
        tex = 'tex',
        sh = 'sh',
        bash = 'sh',
        json = 'jsonc'
    },
})

-- Terminal adjustments
au({ "TermOpen" }, {
    pattern = "term://*",
    group = ag("CleanTerminal", { clear = true }),
    command = "setlocal nonumber norelativenumber nospell | setfiletype terminal",
    desc = "Clean terminal overrides",
})

-- Highlight on yank
au({ "TextYankPost" }, {
    pattern = { "*" },
    group = ag("YankHighlight", { clear = true }),
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = "150",
        })
    end,
    desc = "Highlight text on yank",
})

-- Native templates
group = ag("TemplateFiles", { clear = true })
local templates = {
    ["sh"] = { "*.sh", "*.bash" },
    ["bat"] = { "*.bat", "*.cmd" },
    ["ahk"] = { "*.ahk" },
    ["ps1"] = { "*.ps1", "*.psm1" },
    ["groovy"] = { "*.groovy", "*.gvy", "*.gy", "*.gsh" },
}
for ext, pattern in pairs(templates) do
    au({ "BufNewFile" }, {
        pattern = pattern,
        group = group,
        command = "0r ~/.config/templates/template." .. ext,
        desc = "Load template for '" .. ext .. "'",
    })
end
