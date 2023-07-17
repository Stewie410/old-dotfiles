return {
    -- list ux
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- comments
    {
        "folke/todo-comments.nvim",
        lazy = false,
        opts = {},
    },
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
    },
    {
        "echasnovski/mini.comment",
        version = "*",
        event = "VeryLazy",
        opts = {
            options = {
                custom_commentstring = function()
                    local cs = require("ts_context_commentstring.internal")
                    return cs.calculate_commentstring() or vim.bo.commentstring
                end,
            },
        },
    },

    -- undo
    {
        "mbbill/undotree",
        config = function()
            vim.g.undotree_WindowLayout = true
            vim.g.undotree_SetFocusWhenToggle = true
        end,
    },

    -- navigation
    { "christoomey/vim-tmux-navigator", lazy = false },
}
