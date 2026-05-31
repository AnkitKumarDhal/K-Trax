return {

    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    event = "VeryLazy",
    config = function()
        require("codecompanion").setup {
            -- Set Gemini as the default for all interactions
            strategies = {
                chat = { adapter = "gemini" },
                inline = { adapter = "gemini" },
            },
            adapters = {
                gemini = function()
                    return require("codecompanion.adapters").extend("gemini", {
                        env = {
                            api_key = "GEMINI_API_KEY",
                        },
                        schema = {
                            model = {
                                default = "gemini-2.5-flash",
                            },
                        },
                    })
                end,
            },
            -- Ensure inline suggestions do not trigger automatically
            display = {
                inline = {
                    layout = "buffer",
                },
            },
        }
    end,
}
