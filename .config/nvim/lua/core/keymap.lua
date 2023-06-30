local function map(mode, mapping, action, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, mapping, action, options)
end

-- Do not require <C-w> for split movement
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Do not require <C-w> to reset split size
map("n", "<C-=>", "<C-w>=")

-- Copy/Paste with primary register
map("n", "<leader>py", '"*y')
map("n", "<leader>pp", '"*p')

-- Copy/Paste with system clipboard
map("n", "<leader>sy", '"+y')
map("n", "<leader>sp", '"+p')
