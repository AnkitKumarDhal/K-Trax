-- ~/.config/nvim/lua/core/mappings.lua
local map = vim.keymap.set

-- ── Essentials ───────────────────────────────────────────────────────────────
map("n", ";", ":", { desc = "CMD: Enter command mode" })
map("n", "<Esc>", "<cmd>noh<cr>", { desc = "Search: Clear highlights" })
map("i", "jk", "<Esc>", { desc = "Insert: Escape" })

-- ── File save ────────────────────────────────────────────────────────────────
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "File: Save" })

-- ── Navigation ───────────────────────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Window: Focus Left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window: Focus Right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window: Focus Down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window: Focus Up" })

-- Alt + hjkl for splits (your custom keybind)
map("n", "<A-h>", "<C-w>h", { desc = "Window: Focus Left" })
map("n", "<A-l>", "<C-w>l", { desc = "Window: Focus Right" })
map("n", "<A-j>", "<C-w>j", { desc = "Window: Focus Down" })
map("n", "<A-k>", "<C-w>k", { desc = "Window: Focus Up" })

-- Resize splits with Ctrl+Arrows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Window: Increase Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Window: Decrease Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Window: Decrease Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Window: Increase Width" })

-- ── Splits ───────────────────────────────────────────────────────────────────
map("n", "<leader>h", "<cmd>split<cr>", { desc = "Window: Horizontal Split" })
map("n", "<leader>v", "<cmd>vsplit<cr>", { desc = "Window: Vertical Split" })

-- ── Buffers (NvChad-style) ────────────────────────────────────────────────────
map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Buffer: Next" })
map("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Buffer: Prev" })
map("n", "<leader>x", function()
	local cur = vim.api.nvim_get_current_buf()
	local listed = vim.tbl_filter(function(b)
		return vim.bo[b].buflisted and b ~= cur
	end, vim.api.nvim_list_bufs())
	if #listed > 0 then
		vim.api.nvim_set_current_buf(listed[#listed])
	else
		vim.cmd("enew") -- open empty buffer so nvim-tree doesn't expand
	end
	vim.api.nvim_buf_delete(cur, { force = false })
end, { desc = "Buffer: Close" })
map("n", "<leader>b", "<cmd>enew<cr>", { desc = "Buffer: New" })

-- ── File explorer ─────────────────────────────────────────────────────────────
map("n", "<C-n>", "<cmd>NvimTreeToggle<cr>", { desc = "Explorer: Toggle" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<cr>", { desc = "Explorer: Focus" })

-- ── Telescope ────────────────────────────────────────────────────────────────
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find: Files" })
map(
	"n",
	"<leader>fa",
	"<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>",
	{ desc = "Find: All Files" }
)
map("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Find: Word (grep)" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find: Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Find: Help" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Find: Recent Files" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Find: In Buffer" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git: Commits" })
map("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git: Status" })
map("n", "<leader>pt", "<cmd>Telescope terms<cr>", { desc = "Find: Terminal" })
map("n", "<leader>th", "<cmd>Telescope themes<cr>", { desc = "UI: Themes" })
map("n", "<leader>ma", "<cmd>Telescope marks<cr>", { desc = "Find: Marks" })

-- ── LSP (set on_attach, but also globally as fallback) ────────────────────────
map("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Go to Declaration" })
map("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to Definition" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "LSP: Go to Implementation" })
map("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "LSP: References" })
map("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover Docs" })
map("n", "<leader>ls", vim.lsp.buf.signature_help, { desc = "LSP: Signature Help" })
map("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "LSP: Type Definition" })
map("n", "<leader>ra", vim.lsp.buf.rename, { desc = "LSP: Rename" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code Action" })
map("n", "<leader>lf", function()
	vim.lsp.buf.format({ async = true })
end, { desc = "LSP: Format" })
map("n", "<leader>ds", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "LSP: Buffer Diagnostics" })
map("n", "<leader>dw", "<cmd>Telescope diagnostics<cr>", { desc = "LSP: Workspace Diagnostics" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "LSP: Prev Diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "LSP: Next Diagnostic" })

-- ── Terminal (NvChad-style) ────────────────────────────────────────────────────
-- Toggleterm handles <A-\> itself (defined in its setup)
-- These are extra convenience maps:
map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Terminal: Horizontal" })
map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Terminal: Vertical" })
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Terminal: Float" })
-- Escape from terminal insert mode
map("t", "<C-x>", "<C-\\><C-n>", { desc = "Terminal: Escape" })

-- ── Code runner ───────────────────────────────────────────────────────────────
map("n", "<leader>rr", ":w | :RunCode<cr>", { desc = "Run: Code" })
map("n", "<leader>rc", ":TermExec cmd='exit'<cr>", { desc = "Run: Close Terminal" })

-- ── Debugging ────────────────────────────────────────────────────────────────
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<cr>", { desc = "Debug: Toggle Breakpoint" })
map("n", "<leader>dr", "<cmd>DapContinue<cr>", { desc = "Debug: Start/Continue" })
map("n", "<leader>di", "<cmd>DapStepInto<cr>", { desc = "Debug: Step Into" })
map("n", "<leader>do", "<cmd>DapStepOver<cr>", { desc = "Debug: Step Over" })
map("n", "<leader>dt", "<cmd>DapTerminate<cr>", { desc = "Debug: Terminate" })

-- ── Session ───────────────────────────────────────────────────────────────────
map("n", "<leader>ss", "<cmd>SessionSave<cr>", { desc = "Session: Save" })
map("n", "<leader>sr", "<cmd>SessionRestore<cr>", { desc = "Session: Restore" })
map("n", "<leader>sf", "<cmd>Telescope session-lens<cr>", { desc = "Session: Find" })

-- ── Editing helpers ───────────────────────────────────────────────────────────
-- Semicolon at end of line (your custom map)
map("i", "<C-;>", "<Esc>mzA;<Esc>`za", { desc = "Edit: Append Semicolon" })
map("n", "<leader>;", "mzA;<Esc>`z", { desc = "Edit: Append Semicolon" })

-- Move lines up/down in visual mode
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Edit: Move Line Down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Edit: Move Line Up" })

-- Better indent in visual mode (keep selection)
map("v", "<", "<gv", { desc = "Edit: Indent Left" })
map("v", ">", ">gv", { desc = "Edit: Indent Right" })

-- Don't copy replaced text on paste
map("v", "p", '"_dP', { desc = "Edit: Paste Without Yank" })

-- ── AI (Copilot) ──────────────────────────────────────────────────────────────
-- Copilot accept/dismiss/next is handled in copilot.lua's setup
-- These are for a chat interface if you add one later:
-- map({ "n", "v" }, "<leader>cc", ...)

-- ── Misc ─────────────────────────────────────────────────────────────────────
map("n", "<leader>n", "<cmd>set nu!<cr>", { desc = "UI: Toggle Line Numbers" })
map("n", "<leader>rn", "<cmd>set rnu!<cr>", { desc = "UI: Toggle Relative Numbers" })
map("n", "<leader>ch", "<cmd>NvCheatsheet<cr>", { desc = "UI: Cheatsheet" })
-- Reload colors from pywal/matugen
map("n", "<leader>wc", function()
	require("core.colors").apply()
	print("Colors reloaded from pywal/matugen palette")
end, { desc = "UI: Reload Pywal Colors" })
