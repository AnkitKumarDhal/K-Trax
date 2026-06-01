return {
    "rmagatti/auto-session",
    lazy = false,
    config = function()
        require("auto-session").setup {
            log_level = "error",
            -- Your existing NvimTree logic
            pre_save_cmds = { "NvimTreeClose" },
            post_restore_cmds = {
                function()
                    require("nvim-tree.api").tree.open()
                    vim.schedule(function()
                        vim.cmd "wincmd l"
                    end)
                end,
            },
            session_lens = {
                load_on_setup = true,
                previewer = false,
            },
        }

        local map = vim.keymap.set
        map("n", "<leader>ss", "<cmd>AutoSession save<cr>", { desc = "Session: Save" })
        map("n", "<leader>sr", "<cmd>AutoSession restore<cr>", { desc = "Session: Restore" })
        -- Search sessions using Telescope (built into auto-session)
        map("n", "<leader>sf", "<cmd>AutoSession search<cr>", { desc = "Session: Find" })
    end,
}
