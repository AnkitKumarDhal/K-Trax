return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build  = ":TSUpdate",
        lazy   = false,
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "vim", "lua", "vimdoc",
                    "html", "css", "javascript", "typescript", "tsx",
                    "json", "jsonc",
                    "bash", "markdown", "markdown_inline",
                    "regex", "comment",
                },
                auto_install    = true,
                highlight       = {
                    enable = true,
                    -- disable on very large files to keep things snappy
                    disable = function(_, buf)
                        local max_filesize = 100 * 1024 -- 100KB
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then return true end
                    end,
                },
                indent          = { enable = true },
                autotag         = { enable = true },
                incremental_selection = {
                    enable  = true,
                    keymaps = {
                        init_selection   = "<C-space>",
                        node_incremental = "<C-space>",
                        node_decremental = "<bs>",
                    },
                },
            })
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",
        opts  = {},
    },
}
