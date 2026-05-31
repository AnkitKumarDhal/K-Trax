-- ~/.config/nvim/lua/plugins/copilot.lua
return {
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					keymap = {
						accept = "<Tab>", -- NOTE: conflicts with cmp Tab if cmp visible
						next = "<M-]>",
						prev = "<M-[>",
						trigger = "<M-|>",
						dismiss = "<C-]>",
					},
				},
				panel = { enabled = false },
				filetypes = {
					markdown = false,
					gitcommit = false,
					["*"] = true,
				},
			})
			-- Copilot accept should only fire when cmp menu is NOT open
			-- This patches the Tab key to prioritize cmp over Copilot:
			vim.keymap.set("i", "<Tab>", function()
				if require("copilot.suggestion").is_visible() then
					require("copilot.suggestion").accept()
				else
					local cmp = require("cmp")
					if cmp.visible() then
						cmp.select_next_item()
					else
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
					end
				end
			end, { silent = true, desc = "Tab: cmp/Copilot/fallback" })
		end,
	},
}
