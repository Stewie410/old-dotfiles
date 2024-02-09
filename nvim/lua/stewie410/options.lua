local options = {
    -- line/column numbers
    number = true,
    ruler = true,

    -- always allow mouse interaction
    mouse = "a",

    -- always show previously executed command
    showcmd = true,

    -- actually insert a <Tab> at the start of the line
    smarttab = true,

    -- intuit the indentation of new lines
    smartindent = true,

    -- <tab> should always be 4 spaces
    tabstop = 4,
    softtabstop = 4,
    shiftwidth = 4,
    expandtab = true,

    -- assume emoji are full-width
    emoji = true,

    -- completion mode
    -- wildmode = "longest,list,full",
    wildmode = { 'longest', 'list', 'full' },

    -- open new splits to the right or below current buffer
    splitright = true,
    splitbelow = true,

    -- always draw the sign column
    signcolumn = "yes",

    -- always draw the fold column
    foldcolumn = "1",

    -- faster completion & swap-file writing
    updatetime = 0,

    -- always keep 1 line/char around the cursor
    scrolloff = 1,
    sidescrolloff = 1,

    -- ensure backticks are visible in markdown
    conceallevel = 0,

    -- highlight all matches of search pattern
    hlsearch = true,

    -- pop-up menu height
    pumheight = 10,

    -- use gui fg/bg colors
    termguicolors = true,

    -- auto-abort sequence if not completed within N ms
    timeoutlen = 1000,

    -- highlight the line of the cursor
    cursorline = true,

    -- never wrap long lines
    wrap = false,

    -- allow changing buffers without saving changes
    hidden = true,

    -- color column
    colorcolumn = "80",
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

-- Don't give completion-menu interactive prompts
vim.opt.shortmess:append { c = true }

-- leader key
vim.g.mapleader = " "

-- git-blame support
vim.g.gitblame_enabled = 0

-- show typically hidden characters
vim.opt.list = true
vim.opt.listchars:append {
    tab = ">·",
    trail = "·",
}
