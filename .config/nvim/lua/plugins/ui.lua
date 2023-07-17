return {
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

    -- better notifications
    {
        "rcarriga/nvim-notify",
        keys = {
            {
                "<leader>un",
                function()
                    require("notify").dismiss({ silent = true, pending = true })
                end,
                desc = "Dismiss all notifications",
            },
        },
        opts = {
            fps = 30,
            render = "default",
            stages = "fade",
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
        },
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.notify = require("notify")
        end,
    },

    -- better ui
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end

            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
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

    -- terminal
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = {},
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
