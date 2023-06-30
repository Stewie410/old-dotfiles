vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>b", function() require("nvim-tree.actions.tree.toggle").fn({ file_file = true }) end },
        },
        opts = { filters = { dotfiles = true } },
    },
}
