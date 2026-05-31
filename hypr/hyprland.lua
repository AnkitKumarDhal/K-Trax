--  ╭──────────────────╮
--  │   HYPRLAND.LUA   │
--  ╰──────────────────╯

require("files.appearance")
require("files.input")
require("files.keybinds")
require("files.windows")

-- ══════════════════════════════════════════════════════════════════════════════
--  MONITORS
-- ══════════════════════════════════════════════════════════════════════════════

hl.monitor({
	output = "eDP-1",
	mode = "2880x1800@120.00Hz",
	position = "auto",
	scale = "1.6",
	bitdepth = 10,
	cm = "dcip3",
})

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})

-- ══════════════════════════════════════════════════════════════════════════════
--  AUTOSTART
-- ══════════════════════════════════════════════════════════════════════════════

hl.on("hyprland.start", function()
	-- ── Clipboard ─────────────────────────────────────────────────────────────
	hl.exec_cmd("wl-paste --type text  --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")

	-- ── UI ────────────────────────────────────────────────────────────────────
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("qs")

	-- ── System services ───────────────────────────────────────────────────────
	hl.exec_cmd("kdeconnect-indicator")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("hypridle")
end)

-- ══════════════════════════════════════════════════════════════════════════════
--  ENVIRONMENT VARIABLES
-- ══════════════════════════════════════════════════════════════════════════════

-- ── Cursor ────────────────────────────────────────────────────────────────────
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Catppuccin-Mocha-Muave-Cursors")

-- ── Qt ────────────────────────────────────────────────────────────────────────
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_STYLE_OVERRIDE", "kvantum")

-- ── Backends ──────────────────────────────────────────────────────────────────
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-- ── XDG ───────────────────────────────────────────────────────────────────────
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_MENU_PREFIX", "arch-")

-- ── Firefox ───────────────────────────────────────────────────────────────────
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("MOZ_DISABLE_RDD_SANDBOX", "1")
hl.env("GDK_SCALE", "2")

-- ══════════════════════════════════════════════════════════════════════════════
--   THE END
-- ══════════════════════════════════════════════════════════════════════════════
