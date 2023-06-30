return {
    -- lib
    {
        "stevearc/dressing.nvim",
    },
    {
        "nvim-lua/plenary.nvim",
    },

    -- colorschemes
    {
        "Shatur/neovim-ayu",
        lazy = false,
        priority = 1000,
        config = function()
            require("ayu").setup({ mirage = false, overrides = {} })
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
                styles = { keywords = { italic = false } },
                dim_inactive = true
            })
        end,
    },

    -- statusline
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "ayu",
                    extensions = {
                        "fugitive",
                        "fzf",
                        "toggleterm",
                    },
                },
            })
        end,
    },

    -- notify ux
    {
        "rcarriga/nvim-notify",
        opts = {
            fps = 30,
            render = "default",
            stages = "fade",
            timeout = 3000,
        },
        init = function()
            vim.notify = function(message, level, opts)
                require("notify")(message, level, opts)
            end
        end,
    },

    -- list ux
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- comment ux
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "numToStr/Comment.nvim",
        lazy = false,
        config = function()
            require("Comment").setup()
        end,
    },

    -- undo
    {
        "mbbill/undotree",
        config = function()
            vim.g.undotree_WindowLayout = true
            vim.g.undotree_SetFocusWhenToggle = true
        end,
    },

    -- indentation lines
    {
        "lukas-reineke/indent-blankline.nvim",

        lazy = false,
        config = function()
            require("indent_blankline").setup({
                show_current_context = true,
                show_current_context_start = true,
                space_char_blankline = " ",
            })
        end,
    },
}
