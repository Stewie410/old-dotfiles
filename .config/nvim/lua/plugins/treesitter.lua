return {
    {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        opts = {
            ensure_installed = "all",
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        },
    },
}
