-- ~/.config/nvim/lua/plugins/ui.lua
return {
	-- ── Heirline: tabufline + statusline ─────────────────────────────────────
	{
		"rebelot/heirline.nvim",
		lazy = false, -- must load early for tabline to appear
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local heirline = require("heirline")
			local conditions = require("heirline.conditions")
			local utils = require("heirline.utils")

			-- ── Helpers ──────────────────────────────────────────────────────
			local function get_hl(name)
				return utils.get_highlight(name)
			end

			-- ── Mode map ─────────────────────────────────────────────────────
			local mode_names = {
				n = "NORMAL",
				no = "N-OP",
				nov = "N-OP",
				v = "VISUAL",
				V = "V-LINE",
				[""] = "V-BLOCK",
				s = "SELECT",
				S = "S-LINE",
				[""] = "S-BLOCK",
				i = "INSERT",
				ic = "INSERT",
				R = "REPLACE",
				Rv = "V-REPLACE",
				c = "COMMAND",
				cv = "EX",
				ce = "EX",
				r = "PROMPT",
				rm = "MORE",
				["r?"] = "CONFIRM",
				["!"] = "SHELL",
				t = "TERMINAL",
			}

			local mode_colors = {
				n = "HeirlineMode",
				i = "HeirlineModeInsert",
				v = "HeirlineModeVisual",
				V = "HeirlineModeVisual",
				[""] = "HeirlineModeVisual",
				c = "HeirlineModeCmd",
				R = "HeirlineModeReplace",
				t = "HeirlineModeInsert",
			}

			-- ── STATUS LINE ──────────────────────────────────────────────────

			local Mode = {
				init = function(self)
					self.mode = vim.fn.mode(1)
				end,
				provider = function(self)
					return "  " .. (mode_names[self.mode] or self.mode) .. " "
				end,
				hl = function(self)
					local m = self.mode:sub(1, 1)
					return mode_colors[m] or "HeirlineMode"
				end,
				update = {
					"ModeChanged",
					pattern = "*:*",
					callback = vim.schedule_wrap(function()
						vim.cmd("redrawstatus")
					end),
				},
			}

			local Git = {
				condition = conditions.is_git_repo,
				init = function(self)
					self.status_dict = vim.b.gitsigns_status_dict
				end,
				{
					provider = function(self)
						return "  " .. (self.status_dict.head or "") .. " "
					end,
					hl = "HeirlineGit",
				},
			}

			local FileBlock = {
				init = function(self)
					self.filename = vim.api.nvim_buf_get_name(0)
				end,
			}

			local FileIcon = {
				init = function(self)
					local name = vim.api.nvim_buf_get_name(0)
					local ext = vim.fn.fnamemodify(name, ":e")
					self.icon, self.icon_color =
						require("nvim-web-devicons").get_icon_color(name, ext, { default = true })
				end,
				provider = function(self)
					return self.icon and (" " .. self.icon .. " ")
				end,
				hl = function(self)
					return { fg = self.icon_color }
				end,
			}

			local FileName = {
				provider = function()
					local name = vim.api.nvim_buf_get_name(0)
					if name == "" then
						return "[No Name]"
					end
					return vim.fn.fnamemodify(name, ":~:.") .. " "
				end,
				hl = "HeirlineFile",
			}

			local FileModified = {
				provider = function()
					if vim.bo.modified then
						return "● "
					end
					if not vim.bo.modifiable or vim.bo.readonly then
						return " "
					end
					return ""
				end,
				hl = { fg = utils.get_highlight("HeirlineTabBufModified").fg },
			}

			local Diagnostics = {
				condition = conditions.has_diagnostics,
				init = function(self)
					self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
					self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
					self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
					self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
				end,
				update = { "DiagnosticChanged", "BufEnter" },
				{
					provider = function(self)
						return self.errors > 0 and (" " .. self.errors .. " ") or ""
					end,
					hl = "DiagnosticError",
				},
				{
					provider = function(self)
						return self.warnings > 0 and (" " .. self.warnings .. " ") or ""
					end,
					hl = "DiagnosticWarn",
				},
				{
					provider = function(self)
						return self.hints > 0 and ("󰌶 " .. self.hints .. " ") or ""
					end,
					hl = "DiagnosticHint",
				},
			}

			local LSPActive = {
				condition = conditions.lsp_attached,
				provider = function()
					local names = {}
					for _, server in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
						table.insert(names, server.name)
					end
					return " 󰒋 " .. table.concat(names, " ") .. " "
				end,
				hl = "HeirlineLSP",
			}

			local Ruler = {
				provider = "  %l:%c  %P ",
				hl = "HeirlinePos",
			}

			local Align = { provider = "%=" }
			local Space = { provider = " " }

			local StatusLine = {
				Mode,
				Git,
				Space,
				FileBlock,
				FileIcon,
				FileName,
				FileModified,
				Align,
				Diagnostics,
				LSPActive,
				Ruler,
			}

			-- ── TAB/BUFFER LINE ──────────────────────────────────────────────
			local TablineBufferBlock = {
				init = function(self)
					self.filename = vim.api.nvim_buf_get_name(self.bufnr)
					self.is_active = self.bufnr == vim.api.nvim_get_current_buf()
					self.is_modified = vim.bo[self.bufnr].modified
				end,
				hl = function(self)
					if self.is_active then
						return "HeirlineTabBufActive"
					elseif self.is_modified then
						return "HeirlineTabBufModified"
					else
						return "HeirlineTabBufInactive"
					end
				end,
				-- icon
				{
					init = function(self)
						local name = self.filename
						local ext = vim.fn.fnamemodify(name, ":e")
						self.icon, _ = require("nvim-web-devicons").get_icon(name, ext, { default = true })
					end,
					provider = function(self)
						return " " .. (self.icon or "") .. " "
					end,
				},
				-- filename
				{
					provider = function(self)
						local name = self.filename
						if name == "" then
							return "[No Name]"
						end
						name = vim.fn.fnamemodify(name, ":t")
						return name
					end,
				},
				-- modified indicator
				{
					provider = function(self)
						return self.is_modified and " ●" or "  "
					end,
				},
				-- close button
				{
					provider = " ",
					hl = "HeirlineTabBufClose",
					on_click = {
						callback = function(_, minwid)
							vim.schedule(function()
								vim.api.nvim_buf_delete(minwid, { force = false })
								vim.cmd.redrawtabline()
							end)
						end,
						minwid = function(self)
							return self.bufnr
						end,
						name = "heirline_tabline_close_buf",
					},
				},
				-- clicking a buffer switches to it
				on_click = {
					callback = function(_, minwid)
						vim.api.nvim_win_set_buf(0, minwid)
					end,
					minwid = function(self)
						return self.bufnr
					end,
					name = "heirline_tabline_select_buf",
				},
			}

			local TablineBufferList = utils.make_buflist(
				TablineBufferBlock,
				{ provider = " ", hl = "HeirlineTabBufInactive" }, -- left scroll
				{ provider = " ", hl = "HeirlineTabBufInactive" } -- right scroll
			)

			local TabPages = {
				condition = function()
					return #vim.api.nvim_list_tabpages() > 1
				end,
				utils.make_tablist({
					provider = function(self)
						return "%" .. self.tabnr .. "T " .. self.tabnr .. " %T"
					end,
					hl = function(self)
						return self.is_active and "HeirlineTabpageActive" or "HeirlineTabpageInactive"
					end,
				}),
			}

			local TabLine = {
				TablineBufferList,
				{ provider = "%=" },
				TabPages,
			}

			-- ── Apply ────────────────────────────────────────────────────────
			heirline.setup({
				statusline = StatusLine,
				tabline = TabLine,
			})

			vim.opt.showtabline = 2 -- always show tabline
		end,
	},

	-- ── nvim-tree ─────────────────────────────────────────────────────────────
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			filters = { dotfiles = false },
			disable_netrw = true,
			hijack_netrw = true,
			hijack_cursor = true,
			sync_root_with_cwd = true,
			update_focused_file = { enable = true, update_root = false },
			view = {
				adaptive_size = false,
				side = "left",
				width = 30,
				preserve_window_proportions = true,
			},
			git = { enable = true, ignore = true },
			filesystem_watchers = { enable = true },
			actions = {
				open_file = {
					resize_window = true,
				},
			},
			renderer = {
				root_folder_label = false,
				highlight_git = true,
				highlight_opened_files = "none",
				indent_markers = { enable = true },
				icons = {
					show = { git = true, file = true, folder = true, folder_arrow = true },
					glyphs = {
						default = "",
						symlink = "",
						folder = {
							default = "",
							empty = "",
							empty_open = "",
							open = "",
							symlink = "",
							symlink_open = "",
							arrow_open = "",
							arrow_closed = "",
						},
						git = {
							unstaged = "✗",
							staged = "✓",
							unmerged = "",
							renamed = "➜",
							untracked = "★",
							deleted = "",
							ignored = "◌",
						},
					},
				},
			},
		},
	},

	-- ── Indent blankline ──────────────────────────────────────────────────────
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPost",
		main = "ibl",
		opts = {
			indent = { char = "│", highlight = "IblIndent" },
			scope = { enabled = true, highlight = "IblScope" },
		},
	},

	-- ── Gitsigns ──────────────────────────────────────────────────────────────
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		opts = {
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "󰍵" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "│" },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local function bmap(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end
				bmap("n", "]c", gs.next_hunk, "Git: Next Hunk")
				bmap("n", "[c", gs.prev_hunk, "Git: Prev Hunk")
				bmap("n", "<leader>hs", gs.stage_hunk, "Git: Stage Hunk")
				bmap("n", "<leader>hr", gs.reset_hunk, "Git: Reset Hunk")
				bmap("n", "<leader>hp", gs.preview_hunk, "Git: Preview Hunk")
				bmap("n", "<leader>hb", gs.blame_line, "Git: Blame Line")
				bmap("n", "<leader>hd", gs.diffthis, "Git: Diff This")
			end,
		},
	},

	-- ── Which-key ─────────────────────────────────────────────────────────────
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
			spec = {
				{ "<leader>f", group = "Find/Telescope" },
				{ "<leader>g", group = "Git" },
				{ "<leader>l", group = "LSP" },
				{ "<leader>d", group = "Debug/Diagnostics" },
				{ "<leader>r", group = "Run/Rename" },
				{ "<leader>s", group = "Session" },
				{ "<leader>t", group = "Terminal" },
				{ "<leader>h", group = "Git Hunk / Split" },
				{ "<leader>w", group = "Window/Wallpaper" },
			},
		},
	},

	-- ── Notifications ─────────────────────────────────────────────────────────
	{
		"rcarriga/nvim-notify",
		lazy = false,
		config = function()
			vim.notify = require("notify")
			require("notify").setup({
				background_colour = "Normal",
				render = "compact",
				stages = "fade",
				timeout = 2500,
				max_width = 50,
			})
		end,
	},

	-- ── nvim-web-devicons ─────────────────────────────────────────────────────
	{ "nvim-tree/nvim-web-devicons", lazy = true },
}
