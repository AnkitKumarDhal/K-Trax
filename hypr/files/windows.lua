--  ╭─────────────────╮
--  │     WINDOWS     │
--  ╰─────────────────╯

-- ══════════════════════════════════════════════════════════════════════════════
--  SMART GAPS
-- ══════════════════════════════════════════════════════════════════════════════

-- ── Single tiled window ───────────────────────────────────────────────────────
hl.workspace_rule({
	workspace = "w[tv1]",
	gaps_in = 0,
	gaps_out = {
		top = 0,
		right = 0,
		bottom = 0,
		left = 0,
	},
})
hl.window_rule({
	match = { float = false, workspace = "w[tv1]" },
	border_size = 0,
	rounding = 0,
})

-- ── Single floating window ────────────────────────────────────────────────────
hl.workspace_rule({
	workspace = "f[1]",
	gaps_in = 0,
	gaps_out = { top = 6, right = 0, bottom = 0, left = 0 },
})
hl.window_rule({
	match = { float = true, workspace = "f[1]" },
	border_size = 0,
	rounding = 0,
})

-- ══════════════════════════════════════════════════════════════════════════════
--  GLOBAL RULES
-- ══════════════════════════════════════════════════════════════════════════════

hl.window_rule({
	name = "suppress maximize requests",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix wayland drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

-- ══════════════════════════════════════════════════════════════════════════════
--  PER-APP RULES
-- ══════════════════════════════════════════════════════════════════════════════

-- ── Utilities ─────────────────────────────────────────────────────────────────
hl.window_rule({
	name = "Pavucontrol",
	match = { title = "^(Volume Control)$" },
	float = true,
	size = { 749, 347 },
	move = { 1154, 40 },
})

hl.window_rule({
	name = "Bluetooth TUI",
	match = { class = "^(bluetui)$" },
	float = true,
	size = { 400, 300 },
	move = { 1483, 40 },
	no_dim = true,
})

hl.window_rule({
	name = "Btop",
	match = { class = "^(monitor)$" },
	float = true,
	size = { 841, 458 },
	move = { 1066, 42 },
})

hl.window_rule({
	name = "Qalculate",
	match = { title = "Qalculate!" },
	float = true,
	size = { 341, 213 },
	move = { 1570, 860 },
})

-- ── Overlays ──────────────────────────────────────────────────────────────────
hl.window_rule({
	name = "fum",
	match = { class = "^(fum)$" },
	float = true,
	pin = true,
	size = { 277, 146 },
	move = { 1634, 43 },
	no_dim = true,
})

hl.layer_rule({
	name = "gsr",
	match = { namespace = "^(gsr-ui)$" },
	blur = true,
	ignore_alpha = 0.0,
})

-- ══════════════════════════════════════════════════════════════════════════════
--  LAYER RULES
-- ══════════════════════════════════════════════════════════════════════════════

hl.layer_rule({
	name = "swaync control center",
	match = { namespace = "^(swaync-control-center)$" },
	blur = true,
	ignore_alpha = 0.5,
})

hl.layer_rule({
	name = "swaync notification window",
	match = { namespace = "^(swaync-notification-window)$" },
	blur = true,
	ignore_alpha = 0.5,
})
