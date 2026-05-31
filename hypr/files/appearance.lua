--  ╭─────────────────╮
--  │   APPEARANCE    │
--  ╰─────────────────╯

-- ══════════════════════════════════════════════════════════════════════════════
--  VARIABLES
-- ══════════════════════════════════════════════════════════════════════════════

hl.config({

	-- ── General ───────────────────────────────────────────────────────────────
	general = {
		gaps_in = 3,
		gaps_out = {
			top = 0,
			right = 0,
			bottom = 0,
			left = 0,
		},
		border_size = 1,

		col = {
			active_border = { colors = { "rgb(f4eac0)", "rgb(401810)" }, angle = 45 },
			inactive_border = "rgb(6c757d)",
		},

		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},

	-- ── Decoration ────────────────────────────────────────────────────────────
	decoration = {
		rounding = 6,
		rounding_power = 2.0,
		active_opacity = 1.0,
		inactive_opacity = 0.85,

		dim_inactive = true,
		dim_strength = 0.4,
		dim_special = 0.5,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},

		blur = {
			enabled = true,
			size = 10,
			passes = 4,
			new_optimizations = true,
			vibrancy = 0.1696,
			ignore_opacity = true,
			popups = true,
		},
	},

	-- ── Layouts ───────────────────────────────────────────────────────────────
	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "master",
	},

	-- ── Misc ──────────────────────────────────────────────────────────────────
	misc = {
		force_default_wallpaper = 2,
		disable_hyprland_logo = false,
		font_family = "SpaceMono Nerd Font",
		animate_manual_resizes = true,
		animate_mouse_windowdragging = true,
		focus_on_activate = true,
		middle_click_paste = false,
		vrr = 1,
	},

	-- ── Binds ─────────────────────────────────────────────────────────────────
	binds = {
		hide_special_on_workspace_change = true,
		workspace_back_and_forth = true,
	},

	-- ── Render & cursor ───────────────────────────────────────────────────────
	render = {
		new_render_scheduling = true,
		cm_auto_hdr = 2,
	},

	cursor = {
		warp_on_change_workspace = true,
	},
})

-- ══════════════════════════════════════════════════════════════════════════════
--  CURVES
-- ══════════════════════════════════════════════════════════════════════════════

-- ── Custom ────────────────────────────────────────────────────────────────────
hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.0 } } })
hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0.0, 1.0 } } })
hl.curve("liner", { type = "bezier", points = { { 1.0, 1.0 }, { 1.0, 1.0 } } })

-- ── Borrowed from defaults ────────────────────────────────────────────────────
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0.0, 0.0 }, { 1.0, 1 } } })
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- ══════════════════════════════════════════════════════════════════════════════
--  ANIMATIONS
-- ══════════════════════════════════════════════════════════════════════════════

-- ── Windows ───────────────────────────────────────────────────────────────────
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.8, bezier = "winIn", style = "gnomed" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "winOut", style = "gnomed" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "wind", style = "slide" })

-- ── Borders ───────────────────────────────────────────────────────────────────
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "liner" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "liner", style = "loop" })

-- ── Fades ─────────────────────────────────────────────────────────────────────
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })

-- ── Layers ────────────────────────────────────────────────────────────────────
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })

-- ── Workspaces ────────────────────────────────────────────────────────────────
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "wind" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 3, bezier = "wind", style = "slide top" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 3, bezier = "winOut", style = "slide bottom" })
