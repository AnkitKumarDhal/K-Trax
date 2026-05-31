return {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "neovim/nvim-lspconfig",
    },
    opts = {
        name = { "venv", ".venv" },
        auto_refresh = false,
    },
    keys = {
        { "<leader>sv", "<cmd>VenvSelect<cr>", desc = "Select Python Virtual Environment" },
    },
}
