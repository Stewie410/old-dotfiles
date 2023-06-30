return {
    -- telescope
    {
        "nvim-telescope/telescope.nvim",
        keys = {
            { "<leader>ff", function() require("telescope.builtin").find_files() end },
            { "<leader>fg", function() require("telescope.builtin").get_files() end },
            { "<leader>fb", function() require("telescope.builtin").buffers() end },
            { "<leader>fh", function() require("telescope.builtin").help_tags() end },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-media-files.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
        },
    },

    -- harpoon
    {
        "theprimeagen/harpoon",
        keys = function()
            return {
                { "<leader>af", function()
                    require("harpoon.mark").add_file()
                    vim.notify("Added " .. vim.fn.expand("%"), "info", {
                        title = "Harpoon",
                        timeout = 1000,
                    })
                end },
                { "<C-h>", function() require("harpoon.ui").toggle_quick_menu() end },
                { "<leader>1", function() require("harpoon.ui").nav_file(1) end },
                { "<leader>2", function() require("harpoon.ui").nav_file(2) end },
                { "<leader>3", function() require("harpoon.ui").nav_file(3) end },
                { "<leader>4", function() require("harpoon.ui").nav_file(4) end },
                { "<leader>5", function() require("harpoon.ui").nav_file(5) end },
                { "<leader>6", function() require("harpoon.ui").nav_file(6) end },
            }
        end,
    },
}
