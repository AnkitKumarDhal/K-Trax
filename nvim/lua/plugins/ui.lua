-- ~/.config/nvim/lua/plugins/ui.lua
return {
	{
		"rebelot/heirline.nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local heirline = require("heirline")
			local conditions = require("heirline.conditions")
			local utils = require("heirline.utils")

			local c = require("core.colors").colors
			local mode_names = {
				n = "NORMAL",
				no = "N-OP",
				nov = "N-OP",
				v = "VISUAL",
				V = "V-LINE",
				["\22"] = "V-BLOCK",
				s = "SELECT",
				S = "S-LINE",
				["\19"] = "S-BLOCK",
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
				["\22"] = "HeirlineModeVisual",
				c = "HeirlineModeCmd",
				R = "HeirlineModeReplace",
				t = "HeirlineModeInsert",
			}

			-- ── STATUSLINE ───────────────────────────────────────────────────

			local Mode = {
				init = function(self)
					self.mode = vim.fn.mode(1)
				end,
				provider = function(self)
					return "  " .. (mode_names[self.mode] or self.mode) .. " "
				end,
				hl = function(self)
					return mode_colors[self.mode:sub(1, 1)] or "HeirlineMode"
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
						return "  " .. (self.status_dict and self.status_dict.head or "") .. " "
					end,
					hl = "HeirlineGit",
				},
			}

			local FileIcon = {
				init = function(self)
					local name = vim.api.nvim_buf_get_name(0)
					local ext = vim.fn.fnamemodify(name, ":e")
					self.icon, self.icon_color =
						require("nvim-web-devicons").get_icon_color(name, ext, { default = true })
				end,
				provider = function(self)
					return self.icon and (" " .. self.icon .. " ") or " "
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
						return "●"
					end
					if not vim.bo.modifiable or vim.bo.readonly then
						return " "
					end
					return ""
				end,
				hl = "HeirlineTabBufModified",
			}

			local Diagnostics = {
				condition = conditions.has_diagnostics,
				init = function(self)
					self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
					self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
					self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
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
					for _, s in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
						table.insert(names, s.name)
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

			-- Separator components
			local function sep_right(from_hl, to_hl)
				return { provider = "", hl = { fg = from_hl, bg = to_hl } }
			end

			local ModeSep = {
				provider = "",
				hl = function(self)
					local sep_groups = {
						n = "HeirlineSepModeToBlack",
						i = "HeirlineSepInsertToBlack",
						v = "HeirlineSepVisualToBlack",
						V = "HeirlineSepVisualToBlack",
						[""] = "HeirlineSepVisualToBlack",
						c = "HeirlineSepCmdToBlack",
						R = "HeirlineSepReplaceToBlack",
						t = "HeirlineSepInsertToBlack",
					}
					local mode = vim.fn.mode(1):sub(1, 1)
					return sep_groups[mode] or "HeirlineSepModeToBlack"
				end,
				update = {
					"ModeChanged",
					pattern = "*:*",
					callback = vim.schedule_wrap(function()
						vim.cmd("redrawstatus")
					end),
				},
			}

			local RulerSepLeft = {
				provider = "",
				hl = "HeirlineSepBlackToGray",
			}

			local RulerSepRight = {
				provider = "",
				hl = "HeirlineSepGrayToEnd",
			}

			local StatusLine = {
				Mode,
				ModeSep, -- colored wedge after mode pill
				Git,
				Space,
				FileIcon,
				FileName,
				FileModified,
				Align,
				Diagnostics,
				LSPActive,
				RulerSepLeft, -- wedge before ruler
				Ruler,
				RulerSepRight, -- closing wedge after ruler
			}
			-- ── TABLINE ──────────────────────────────────────────────────────

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
						local ext = vim.fn.fnamemodify(self.filename, ":e")
						self.icon = require("nvim-web-devicons").get_icon(self.filename, ext, { default = true })
					end,
					provider = function(self)
						return " " .. (self.icon or "") .. " "
					end,
				},
				-- name
				{
					provider = function(self)
						if self.filename == "" then
							return "[No Name]"
						end
						return vim.fn.fnamemodify(self.filename, ":t")
					end,
				},
				-- modified dot
				{
					provider = function(self)
						return self.is_modified and " ●" or ""
					end,
				},
				-- close button — hl is now conditional so it stays inside the tab's bg
				{
					provider = "  ",
					hl = function(self)
						if self.is_active then
							return "HeirlineTabBufCloseActive"
						else
							return "HeirlineTabBufCloseInactive"
						end
					end,
					on_click = {
						callback = function(_, minwid)
							vim.schedule(function()
								local cur = minwid
								-- Only switch if this is the currently displayed buffer
								if vim.api.nvim_get_current_buf() == cur then
									local listed = vim.tbl_filter(function(b)
										return vim.bo[b].buflisted and b ~= cur
									end, vim.api.nvim_list_bufs())
									if #listed > 0 then
										vim.api.nvim_set_current_buf(listed[#listed])
									else
										vim.cmd("enew")
									end
								end
								pcall(vim.api.nvim_buf_delete, cur, { force = false })
								vim.cmd.redrawtabline()
							end)
						end,
						minwid = function(self)
							return self.bufnr
						end,
						name = "heirline_tabline_close_buf",
					},
				}, -- right cap — visually closes the tab shape
				{
					provider = "", -- U+E0B0 powerline right arrow — acts as end cap
					hl = function(self)
						if self.is_active then
							return { fg = c.blue, bg = c.black }
						elseif self.is_modified then
							return { fg = c.brblack, bg = c.black }
						else
							return { fg = c.brblack, bg = c.black }
						end
					end,
				},
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
				{ provider = " ", hl = "HeirlineTabBufInactive" },
				{ provider = " ", hl = "HeirlineTabBufInactive" }
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

			-- Offset block: fills the space above nvim-tree so tabs start
			-- at the same x position as the file content
			local TablineOffset = {
				condition = function(self)
					-- find the leftmost window
					local wins = vim.api.nvim_tabpage_list_wins(0)
					table.sort(wins, function(a, b)
						return vim.api.nvim_win_get_position(a)[2] < vim.api.nvim_win_get_position(b)[2]
					end)
					local leftwin = wins[1]
					local buf = vim.api.nvim_win_get_buf(leftwin)
					if vim.bo[buf].filetype == "NvimTree" then
						self.winid = leftwin
						return true
					end
				end,
				provider = function(self)
					local width = vim.api.nvim_win_get_width(self.winid) + 1 -- +1 for separator
					local title = "Files"
					local pad = math.max(0, math.floor((width - #title) / 2))
					return string.rep(" ", pad) .. title .. string.rep(" ", width - pad - #title)
				end,
				hl = "HeirlineTabBufInactive",
			}

			local TabLine = {
				TablineOffset,
				-- separator between Files label and first buffer tab
				{
					condition = function()
						-- only show when nvim-tree is open (same condition as offset)
						local wins = vim.api.nvim_tabpage_list_wins(0)
						table.sort(wins, function(a, b)
							return vim.api.nvim_win_get_position(a)[2] < vim.api.nvim_win_get_position(b)[2]
						end)
						local buf = vim.api.nvim_win_get_buf(wins[1])
						return vim.bo[buf].filetype == "NvimTree"
					end,
					provider = "│",
					hl = "HeirlineTabSep",
				},
				TablineBufferList,
				{ provider = "%=" },
				TabPages,
			}

			heirline.setup({
				statusline = StatusLine,
				tabline = TabLine,
			})

			vim.opt.showtabline = 2
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
			actions = { open_file = { resize_window = true } },
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
							arrow_open = "",
							arrow_closed = "",
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
				{ "<leader>n", group = "NPM" },
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

	{ "nvim-tree/nvim-web-devicons", lazy = true },
}
