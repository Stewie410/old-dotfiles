return {
    -- list ux
    { "folke/trouble.nvim" },

    -- comments
    { "folke/todo-comments.nvim", opts = {} },
    {
        "numToStr/Comment.nvim",
        opts = {},
        lazy = false,
    },

    -- undo
    {
        "mbbill/undotree",
        config = function()
            vim.g.undotree_WindowLayout = true
            vim.g.undotree_SetFocusWhenToggle = true
        end,
    },
}
