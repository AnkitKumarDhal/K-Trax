-- ~/.config/nvim/lua/plugins/tools.lua
return {
	-- ── Conform: formatting ───────────────────────────────────────────────────
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					css = { "prettier" },
					scss = { "prettier" },
					html = { "prettier" },
					javascript = { "prettier" },
					javascriptreact = { "prettier" },
					typescript = { "prettier" },
					typescriptreact = { "prettier" },
					json = { "prettier" },
					jsonc = { "prettier" },
					markdown = { "prettier" },
				},
				format_on_save = function(bufnr)
					if vim.b[bufnr].autoformat == false then
						return
					end
					return { timeout_ms = 500, lsp_fallback = true }
				end,
			})
		end,
	},

	-- ── Toggleterm ────────────────────────────────────────────────────────────
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		keys = { { "<A-\\>", desc = "Terminal: Toggle" } },
		config = function()
			require("toggleterm").setup({
				size = function(term)
					if term.direction == "horizontal" then
						return 12
					elseif term.direction == "vertical" then
						return vim.o.columns * 0.4
					end
				end,
				open_mapping = [[<a-\>]],
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
				shade_filetypes = {},
			})
		end,
	},

	-- ── Code Runner ──────────────────────────────────────────────────────────
	{
		"CRAG666/code_runner.nvim",
		dependencies = "akinsho/toggleterm.nvim",
		cmd = "RunCode",
		config = function()
			require("code_runner").setup({
				mode = "toggleterm",
				filetype = {
					javascript = "node",
					typescript = "npx ts-node",
					python = "python3 -u",
					cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
					lua = "luafile %",
					html = "open", -- opens in default browser on Linux: xdg-open
				},
			})
		end,
	},

	-- ── DAP ──────────────────────────────────────────────────────────────────
	{
		"mfussenegger/nvim-dap",
		cmd = { "DapToggleBreakpoint", "DapContinue" },
		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
				dependencies = "nvim-neotest/nvim-nio",
				config = function()
					local dap, dapui = require("dap"), require("dapui")
					dapui.setup()
					dap.listeners.after.event_initialized["dapui"] = dapui.open
					dap.listeners.before.event_terminated["dapui"] = dapui.close
					dap.listeners.before.event_exited["dapui"] = dapui.close
				end,
			},
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
			},
		},
		config = function()
			local dap = require("dap")
			-- LLDB for C/C++
			dap.adapters.lldb = {
				type = "executable",
				command = "/usr/bin/lldb-dap",
				name = "lldb",
			}
			dap.configurations.c = {
				{
					name = "Launch",
					type = "lldb",
					request = "launch",
					program = function()
						return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}
			dap.configurations.cpp = dap.configurations.c
		end,
	},

	-- ── Auto-session ─────────────────────────────────────────────────────────
	{
		"rmagatti/auto-session",
		lazy = false,
		config = function()
			require("auto-session").setup({
				log_level = "error",
				pre_save_cmds = { "NvimTreeClose" },
				post_restore_cmds = {
					function()
						require("nvim-tree.api").tree.open()
						vim.schedule(function()
							vim.cmd("wincmd l")
						end)
					end,
				},
				session_lens = {
					load_on_setup = true,
					previewer = false,
				},
			})
		end,
	},
}
