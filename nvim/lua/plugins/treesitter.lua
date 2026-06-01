-- ~/.config/nvim/lua/plugins/treesitter.lua
return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- The `main` branch uses vim.treesitter directly; parsers are
			-- installed with TSInstall / ensure_installed via the plugin itself.
			require("nvim-treesitter").setup({
				highlight = { enable = true },
				ensure_installed = {
					"vim",
					"lua",
					"vimdoc",
					"html",
					"css",
					"javascript",
					"typescript",
					"tsx",
					"json",
					"jsonc",
					"bash",
					"markdown",
					"markdown_inline",
					"regex",
					"comment",
				},
				auto_install = true,
			})

			-- Highlight, indent, fold are enabled via vim.treesitter directly
			-- on the new main branch:
			vim.treesitter.language.register("markdown", "mdx")

			-- Incremental selection (still works on main)
			vim.keymap.set("n", "<C-space>", ":TSNodeUnderCursor<cr>", { desc = "TS: Node Under Cursor" })
		end,
	},

	-- nvim-ts-autotag is a separate plugin, keep it here
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {},
	},
}
