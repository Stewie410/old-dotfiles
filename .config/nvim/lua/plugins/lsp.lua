return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        lazy = false,
        dependencies = {
            { "neovim/nvim-lspconfig" },
            {
                "williamboman/mason.nvim",
                build = function() vim.cmd([[MasonUpdate]]) end,
            },
            { "williamboman/mason-lspconfig.nvim" },
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "L3MON4D3/LuaSnip" },
        },
        config = function()
            local lsp = require("lsp-zero")

            lsp.preset("recommended")
            lsp.ensure_installed({
                "awk_ls",
                "bashls",
                "diagnosticls",
                "docker_compose_language_service",
                "dockerls",
                "groovyls",
                "html",
                "jdtls",
                "jsonls",
                "lemminx",
                "lua_ls",
                "ltex",
                "pyright",
                "sqlls",
                "terraformls",
                "texlab",
                "tsserver",
                "vimls",
                "yamlls",
            })

            local cmp = require("cmp")
            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            local cmp_mappings = lsp.defaults.cmp_mappings({
                ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
                ["<Tab>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            })
            lsp.setup_nvim_cmp({ mapping = cmp_mappings })

            lsp.set_sign_icons({
                error = "\u{ea87}", -- 
                warn = "\u{ea6c}",  -- 
                hint = "\u{ea61}",  -- 
                info = "\u{ea74}",  -- 
            })

            lsp.on_attach(function(_, bufnr)
                local opts = { buffer = bufnr, remap = false }
                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set("n", "<leader>a", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.references() end, opts)
                vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
                vim.keymap.set("n", "<leader>bf", function() vim.lsp.buf.format({ async = false }) end, opts)
            end)

            lsp.set_server_config({
                on_init = function(client)
                    client.server_capabilities.semanticTokensProvder = nil
                end,
            })

            require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

            lsp.setup()
        end,
    },

    -- highlight under cursor
    {
        "RRethy/vim-illuminate",
        lazy = false,
    },

    -- auto-pairs
    {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
        opts = {},
    },

    -- surround
    {
        "echasnovski/mini.surround",
        version = "*",
        opts = {},
    },

    -- syntax/highlighting
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
