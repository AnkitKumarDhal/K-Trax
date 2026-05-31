return {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
        require("copilot").setup {
            suggestion = {
                enabled = true,
                auto_trigger = false, -- only shows when you press the trigger key
                keymap = {
                    accept = "<Tab>",
                    next = "<M-]>",
                    prev = "<M-[>",
                    trigger = "<M-l>", -- press this to ask for a suggestion
                    dismiss = "<C-]>",
                },
            },
            panel = { enabled = false }, -- don't need the panel
            filetypes = {
                markdown = false,
                gitcommit = false,
                ["*"] = true,
            },
        }
    end,
}
