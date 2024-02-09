return {
    -- git
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G" },
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, lhs, rhs, desc)
                    local opts = { buffer = bufnr, desc = desc }
                    vim.keymap.set(mode, lhs, rhs, opts)
                end

                -- stylua: ignore start
                map("n", "]h", gs.next_hunk, "Next Hunk")
                map("n", "[h", gs.prev_hunk, "Previous Hunk")
                map({ "n", "v" }, "<leader>ghs", ":GitSigns stage_hunk<CR>", "Stage Hunk")
                map({ "n", "v" }, "<leader>ghr", ":GitSigns reset_hunk<CR>", "Reset Hunk")
                map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
                map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
                map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
                map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
                map("n", "<leader>ghb", function()
                    gs.blame_line({ full = true })
                end, "Blame Line")
                map("n", "<leader>ghd", gs.diffthis, "Diff This")
                map("n", "<leader>ghD", function()
                    gs.diffthis("~")
                end, "Diff This ~")
                map({ "o", "x" }, "ih", ":<C-U>GitSigns select_hunk<CR>", "GitSigns Select Hunk")
            end,
        },
    },

    -- non-git
    {
        "vim-scripts/vcscommand.vim",
        cmd = {
            "VCSAdd",
            "VCSAnnotate",
            "VCSAnnotate",
            "VCSBlame",
            "VCSCommit",
            "VCSDelete",
            "VCSDiff",
            "VCSGotoOriginal",
            "VCSInfo",
            "VCSLock",
            "VCSLog",
            "VCSRemove",
            "VCSRevert",
            "VCSReview",
            "VCSStatus",
            "VCSUpdate",
            "VCSVimDiff",
        },
        config = function()
            local opts = {
                CommitOnWrite = 0,
                DeleteOnHide = 1,
                DisableMappings = 1,
                DisableExtensionMappings = 1,
            }

            for k, v in pairs(opts) do
                vim.g["VCSCommand" .. k] = v
            end
        end,
    },
}
