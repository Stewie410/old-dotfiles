return {
    -- icons
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },

    -- ui components
    {
        "MunifTanjim/nui.nvim",
        lazy = true,
    },

    -- colorschemes
    {
        "Shatur/neovim-ayu",
        priority = 1000,
        config = function()
            local colors = require("ayu.colors")
            colors.generate()
            require("ayu").setup({
                mirage = false,
                overrides = { Comment = { fg = colors.comment } },
            })
        end,
    },
    {
        "arturgoms/moonbow.nvim",
    },
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                style = "night",
                light_style = "day",
                transparent = false,
                terminal_colors = true,
                styles = {
                    comments = { italic = false },
                    keywords = { italic = false },
                },
                dim_inactive = true,
            })
        end,
    },

    -- better notifications
    {
        "rcarriga/nvim-notify",
        opts = {
            fps = 30,
            render = "default",
            stages = "fade",
            timeout = 3000,
        },
        init = function()
            vim.notify = require("notify")
        end,
    },

    -- better ui
    {
        "stevearc/dressing.nvim",
        lazy = false,
        opts = {},
    },

    -- statusline
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        config = function()
            require("lualine").setup({
                options = {
                    theme = "ayu",
                    extensions = { "fugitive", "fzf", "toggleterm" },
                },
            })
        end,
    },

    -- bufferline
    {
        "akinsho/bufferline.nvim",
        lazy = false,
        opts = {},
    },

    -- file browser
    {
        "nvim-tree/nvim-tree.lua",
        keys = {
            { "<leader>b", function() require("nvim-tree.actions.tree.toggle").fn({ file_file = true }) end },
        },
        opts = { filters = { dotfiles = true } },
        init = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
        end,
    },

    -- indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            char = "│",
            space_char_blankline = " ",
            filetype_exclude = {
                "help",
                "alpha",
                "dashboard",
                "Trouble",
                "lazy",
                "mason",
                "notify",
                "toggleterm",
                "lazyterm",
            },
            show_current_context = true,
            show_current_context_start = true,
            show_trailing_blankline_indent = false,
        },
    },

    -- keymap display
    -- TODO register keybinds...
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {},
    },
}
