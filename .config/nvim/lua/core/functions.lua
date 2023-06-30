local cmd = vim.api.nvim_create_user_command
local au = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup

-- alias 'filetype detect'
cmd("FTD", "filetype detect", {})

-- toggle tabstop between 2/4/8 spaces (legacy)
cmd("TTS", function()
    local ts = vim.opt.tabstop
    if ts == 2 then
        ts = 4
    elseif ts == 4 then
        ts = 8
    elseif ts == 8 then
        ts = 2
    end

    vim.opt.tabstop = ts
    vim.opt.softtabstop = ts
    vim.opt.shiftwidth = ts
end, { silent = true })

-- trim trailing whitespace on write
local group = ag("FormatOnSave", { clear = true })
au("BufWritePre", {
    pattern = { "*" },
    group = group,
    callback = function()
        local view = vim.fn.winsaveview()
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.fn.winrestview(view)
    end,
})

-- trim trailing newlines on write
au("BufWritePre", {
    pattern = { "*" },
    group = group,
    callback = function()
        local pos = vim.fn.getpos(".")
        vim.cmd([[keeppatterns %s#\($\n\s*\)\+\%$##]])
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
local group = ag("TemplateFiles")
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
