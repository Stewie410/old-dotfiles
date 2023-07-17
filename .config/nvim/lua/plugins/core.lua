return {
    -- list ux
    { "folke/trouble.nvim" },

    -- comments
    { "folke/todo-comments.nvim", opts = {} },
    { "numToStr/Comment.nvim",    opts = {} },

    -- undo
    {
        "mbbill/undotree",
        config = function()
            vim.g.undotree_WindowLayout = true
            vim.g.undotree_SetFocusWhenToggle = true
        end,
    },

    -- navigation
    {
        "numToStr/Navigator.nvim",
        keys = {
            {
                "<C-h>",
                function() require("Navigator").left() end,
                desc = "Navigate left",
                mode = { "n", "t" },
            },
            {
                "<C-j>",
                function() require("Navigator").down() end,
                desc = "Navigate down",
                mode = { "n", "t" },
            },
            {
                "<C-k>",
                function() require("Navigator").up() end,
                desc = "Navigate up",
                mode = { "n", "t" },
            },
            {
                "<C-l>",
                function() require("Navigator").right() end,
                desc = "Navigate right",
                mode = { "n", "t" },
            },
            {
                "<C-\\>",
                function() require("Navigator").previous() end,
                desc = "Navigate to previous split/pane",
                mode = { "n", "t" },
            },
        },
        opts = {},
    }
}
