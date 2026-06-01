return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup {
            size = 9,
            open_mapping = [[<a-\>]],
            shade_filetypes = { "none", "lazy", "lspsagaoutline" },
            direction = "float",
            float_opts = {
                border = "curved",
                width = function()
                    return math.floor(vim.o.columns * 0.8)
                end,
                height = function()
                    return math.floor(vim.o.lines * 0.8)
                end,
            },
        }
    end,
}
