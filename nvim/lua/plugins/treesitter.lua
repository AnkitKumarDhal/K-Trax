return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			-- 1. Install missing parsers manually
			local ensure_installed = {
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
			}
			local already_installed = require("nvim-treesitter.config").get_installed()
			local to_install = vim.iter(ensure_installed)
				:filter(function(parser)
					return not vim.tbl_contains(already_installed, parser)
				end)
				:totable()

			if #to_install > 0 then
				require("nvim-treesitter").install(to_install)
			end

			-- 2. Enable Native Highlighting, Folds, and Indents
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
				callback = function(ev)
					local ft = vim.bo[ev.buf].filetype
					if ft ~= "" and ft ~= "NvimTree" then
						-- Start Treesitter highlighting (disables regex syntax)
						pcall(vim.treesitter.start, ev.buf)

						-- Enable Treesitter folds
						vim.opt_local.foldmethod = "expr"
						vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
						vim.opt_local.foldenable = false

						-- Enable Treesitter indentation
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {},
	},
}
