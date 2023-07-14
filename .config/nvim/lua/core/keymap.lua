local function map(mode, mapping, action, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, mapping, action, options)
end

-- Do not require <C-w> for split movement
map("n", "<C-h>", "<C-w>h", { desc = "Nav left" })
map("n", "<C-j>", "<C-w>j", { desc = "Nav down " })
map("n", "<C-k>", "<C-w>k", { desc = "Nav up" })
map("n", "<C-l>", "<C-w>l", { desc = "Nav right" })

-- Do not require <C-w> to reset split size
map("n", "<C-=>", "<C-w>=", { desc = "Reset split size" })

-- Copy/Paste with primary register
map("n", "<leader>py", '"*y', { desc = "Yank to primary register" })
map("n", "<leader>pp", '"*p', { desc = "Paste from primary register" })

-- Copy/Paste with system clipboard
map("n", "<leader>sy", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>sp", '"+p', { desc = "Paste to system clipboard" })
