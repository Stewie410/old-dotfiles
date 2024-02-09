return {
    -- telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-media-files.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
        },
        keys = {
            {
                "<leader>tf",
                function() require("telescope.builtin").find_files() end,
                desc = "Find Files",
            },
            {
                "<leader>tg",
                function() require("telescope.builtin").git_files() end,
                desc = "Find git files"
            },
            {
                "<leader>tb",
                function() require("telescope.builtin").buffers() end,
                desc = "Switch buffers",
            },
            {
                "<leader>t/",
                function() require("telescope.builtin").live_grep() end,
                desc = "Live grep files in current directory",
            },
            {
                "<leader>th:",
                function() require("telescope.builtin").command_history() end,
                desc = "Command history",
            },
            {
                "<leader>th/",
                function() require("telescope.builtin").search_history() end,
                desc = "Search history",
            },
        },
    },

    -- harpoon
    {
        "theprimeagen/harpoon",
        keys = {
            {
                "<leader>ha",
                function()
                    require("harpoon.mark").add_file()
                    require("notify")("Added " .. vim.fn.expand("%"), "info", {
                        title = "Harpoon",
                        timeout = 1000,
                    })
                end,
                desc = "Add file to harpoon",
            },
            {
                "<leader>hp",
                function() require("harpoon.ui").toggle_quick_menu() end,
                desc = "Toggle Harpoon quick menu",
            },
            {
                "<leader>h1",
                function() require("harpoon.ui").nav_file(1) end,
                desc = "Harpoon file (1)",
            },
            {
                "<leader>h2",
                function() require("harpoon.ui").nav_file(2) end,
                desc = "Harpoon file (2)",
            },
            {
                "<leader>h3",
                function() require("harpoon.ui").nav_file(3) end,
                desc = "Harpoon file (3)",
            },
            {
                "<leader>h4",
                function() require("harpoon.ui").nav_file(4) end,
                desc = "Harpoon file (4)",
            },
            {
                "<leader>h5",
                function() require("harpoon.ui").nav_file(5) end,
                desc = "Harpoon file (5)",
            },
            {
                "<leader>h6",
                function() require("harpoon.ui").nav_file(6) end,
                desc = "Harpoon file (6)",
            },
        },
    },
}
