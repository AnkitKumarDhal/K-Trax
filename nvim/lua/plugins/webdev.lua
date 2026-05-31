-- ~/.config/nvim/lua/plugins/webdev.lua
-- Web dev extras: color preview, CSS sorting, package.json tools

return {
	-- ── Inline color preview (hex/rgb/hsl/tailwind classes) ──────────────────
	{
		"NvChad/nvim-colorizer.lua",
		event = "BufReadPost",
		opts = {
			filetypes = { "*" },
			user_default_options = {
				RGB = true,
				RRGGBB = true,
				names = true, -- "Red", "Blue", etc.
				RRGGBBAA = true,
				css = true,
				tailwind = "both", -- normal + lsp
				mode = "background",
			},
		},
	},

	-- ── package.json helper (see versions, update deps) ───────────────────────
	{
		"vuki656/package-info.nvim",
		dependencies = "MunifTanjim/nui.nvim",
		ft = "json",
		config = function()
			require("package-info").setup({ colors = { up_to_date = "#3C4048", outdated = "#d19a66" } })
			local map = vim.keymap.set
			map("n", "<leader>ns", require("package-info").show, { desc = "NPM: Show Versions" })
			map("n", "<leader>nc", require("package-info").hide, { desc = "NPM: Hide Versions" })
			map("n", "<leader>nu", require("package-info").update, { desc = "NPM: Update Package" })
			map("n", "<leader>nd", require("package-info").delete, { desc = "NPM: Delete Package" })
			map("n", "<leader>ni", require("package-info").install, { desc = "NPM: Install Package" })
		end,
	},

	-- ── CSS modules / Tailwind class sorting ──────────────────────────────────
	-- (Prettier handles sorting via prettier-plugin-tailwindcss — no extra plugin needed)

	-- ── Markdown preview (for README and docs) ────────────────────────────────
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = function()
			vim.fn.jobstart({ "npm", "install", vim.fn.expand("%") })
		end,
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = "markdown",
	},

	-- ── Comment.nvim (gcc to comment a line, gc in visual) ───────────────────
	{
		"numToStr/Comment.nvim",
		event = "BufReadPost",
		dependencies = {
			{
				-- JSX-aware commenting (uses treesitter to pick the right comment style)
				"JoosepAlviste/nvim-ts-context-commentstring",
				opts = { enable_autocmd = false },
			},
		},
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},

	-- ── Todo comments (TODO:, FIXME:, NOTE: highlighting) ────────────────────
	{
		"folke/todo-comments.nvim",
		event = "BufReadPost",
		dependencies = "nvim-lua/plenary.nvim",
		opts = {},
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Todo: Next",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Todo: Prev",
			},
			{ "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find: TODOs" },
		},
	},

	-- ── Surround (ysiw", cs"', ds") ───────────────────────────────────────────
	{
		"kylechui/nvim-surround",
		event = "BufReadPost",
		version = "*",
		opts = {},
	},

	-- ── Flash: better f/t/s navigation ───────────────────────────────────────
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				function()
					require("flash").jump()
				end,
				desc = "Flash: Jump",
			},
			{
				"S",
				function()
					require("flash").treesitter()
				end,
				desc = "Flash: Treesitter",
			},
			{
				"r",
				function()
					require("flash").remote()
				end,
				mode = "o",
				desc = "Flash: Remote",
			},
			{
				"R",
				function()
					require("flash").treesitter_search()
				end,
				mode = { "o", "x" },
				desc = "Flash: Treesitter Search",
			},
		},
	},
}
