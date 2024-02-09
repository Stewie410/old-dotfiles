local scheme = "ayu"
local fallback = "slate"
local status_ok, _ = pcall(vim.cmd.colorscheme, scheme)

if not status_ok then
    vim.notify("Missing colorscheme: '" .. scheme .. "'!")
    vim.notify("Applying fallback colorscheme: '" .. fallback .. "'")

    vim.cmd.colorscheme(fallback)
end
