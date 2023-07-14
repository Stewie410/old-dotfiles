local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    -- bootstrap lazy.nvim
    -- stylua: ignore
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
        lazypath })
end
vim.opt.runtimepath:prepend(vim.env.LAZY or lazypath)

require("lazy").setup("plugins", {
    defaults = {
        lazy = true,
        version = false,
    },
    checker = { enabled = true },
    install = { colorscheme = { "ayu" } },
    performance = {
        cache = { enabled = true },
        rtp = {
            "gzip",
            "zip",
            "zipPlugin",
            "tar",
            "tarPlugin",
            "getscript",
            "getscriptPlugin",
            "vimball",
            "vimballPlugin",
            "2html_plugin",
            "logipat",
            "rrhelper",
            "spellfile_plugin",
            "matchit",
        },
    },
})
