--  ╭─────────────────╮
--  │      INPUT      │
--  ╰─────────────────╯

-- ══════════════════════════════════════════════════════════════════════════════
--  KEYBOARD & MOUSE
-- ══════════════════════════════════════════════════════════════════════════════

hl.config({
	input = {

		-- ── Keyboard ──────────────────────────────────────────────────────────
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		numlock_by_default = true,
		repeat_delay = 300,
		repeat_rate = 25,

		-- ── Mouse ─────────────────────────────────────────────────────────────
		follow_mouse = 1,
		sensitivity = 0,
		accel_profile = "adaptive",

		-- ── Touchpad ──────────────────────────────────────────────────────────
		touchpad = {
			natural_scroll = true,
			tap_to_click = true,
			drag_lock = 1,
		},
	},
})

-- ══════════════════════════════════════════════════════════════════════════════
--  GESTURES
-- ══════════════════════════════════════════════════════════════════════════════

-- ── 3-finger ──────────────────────────────────────────────────────────────────
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down", mods = "ALT", action = "close" })
hl.gesture({
	fingers = 3,
	direction = "up",
	action = function()
		hl.dispatch(hl.dsp.global("quickshell:launcherToggle"))
	end,
})

-- ── 4-finger ──────────────────────────────────────────────────────────────────
hl.gesture({ fingers = 4, direction = "swipe", action = "resize" })
hl.gesture({
	fingers = 4,
	direction = "down",
	mods = "CTRL",
	action = function()
		hl.exec_cmd("wlogout")
	end,
})
