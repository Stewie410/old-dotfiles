local Remap = require("util.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local xnoremap = Remap.xnoremap
local tnoremap = Remap.tnoremap
local inoremap = Remap.inoremap
local nmap = Remap.nmap

-- leader
vim.g.mapleader = " "

-- open a terminal
nnoremap("<leader>t", ":vsp<CR>:term<CR>:startinsert<CR>", {
    silent = true,
    desc = "Quickly open a terminal",
})

-- navigation
nnoremap("<C-h>", ":wincmd h<CR>", { desc = "Navigate Left" })
nnoremap("<C-j>", ":wincmd j<CR>", { desc = "Navigate Down" })
nnoremap("<C-k>", ":wincmd k<CR>", { desc = "Navigate Up" })
nnoremap("<C-l>", ":wincmd l<CR>", { desc = "Navigate Right" })

tnoremap("<C-h>", "<C-\\><C-n><C-w>h", { desc = "Navigate Left" })
tnoremap("<C-j>", "<C-\\><C-n><C-w>j", { desc = "Navigate Down" })
tnoremap("<C-k>", "<C-\\><C-n><C-w>k", { desc = "Navigate Up" })
tnoremap("<C-l>", "<C-\\><C-n><C-w>l", { desc = "Navigate Right" })

nnoremap("<leader><Tab>", ":bn<CR>", { desc = "Next Buffer" })
nnoremap("<leader><S-Tab>", ":bp<CR>", { desc = "Previous Buffer" })

-- reset split sizing
nnoremap("<C-=>", ":wincmd =<CR>", { desc = "Reset split size" })

-- yank to system clipboard
nnoremap("<leader>y", '"+y', { desc = "Yank word to system clipboard" })
nnoremap("<leader>Y", '"+y$', { desc = "Yank until EOL system clipboard" })
nnoremap("<leader>yy", '"+yy', { desc = "Yank line to system clipboard" })
vnoremap("<leader>y", '"+y', { desc = "Yank word to system clipboard" })

-- paste from system clipboard
nnoremap("<leader>p", '"+p', { desc = "Paste from system clipboard" })

-- increment/decrement
nnoremap("+", "<C-a>", { desc = "Increment" })
nnoremap("-", "<C-x>", { desc = "Decrement" })
vnoremap("+", "<C-a>", { desc = "Increment" })
vnoremap("-", "<C-x>", { desc = "Decrement" })
vnoremap("g+", "g<C-a>", { desc = "Increment selection" })
vnoremap("g-", "g<C-x>", { desc = "Decrement selection" })
