return {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
    config = function()
        require "nvchad.configs.lspconfig" -- Ensure NvChad defaults load
        local navic = require "navic"

        navic.setup {
            lsp = { auto_attach = true },
            highlight = true,
            separator = " > ",
        }

        -- This puts the breadcrumbs in the "winbar" (top of the window)
        vim.o.winbar = "%{%v:lua.require'navic'.get_location()%}"
    end,
}
