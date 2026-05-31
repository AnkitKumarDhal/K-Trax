--  ╭─────────────────╮
--  │    KEYBINDS     │
--  ╰─────────────────╯

-- ══════════════════════════════════════════════════════════════════════════════
--                                VARIABLES
-- ══════════════════════════════════════════════════════════════════════════════

local terminal = "kitty"
local fileManager = "kitty yazi"
local browser = "zen-browser"
local menu = "quickshell:launcherToggle"
local emoji = "quickshell:emojiPickerToggle"
local mediaPopup = "quickshell:mediaPlayerPopup"
local editor = "kitty --override window_padding_width=0 --override background_opacity=1  -e nvim"

local mainMod = "SUPER"

-- ══════════════════════════════════════════════════════════════════════════════
--                                LAUNCHERS
-- ══════════════════════════════════════════════════════════════════════════════

-- ── Core apps ─────────────────────────────────────────────────────────────────
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("dolphin"))

-- ── App launcher ──────────────────────────────────────────────────────────────
hl.bind(mainMod .. " + SPACE", hl.dsp.global(menu))
hl.bind("XF86Search", hl.dsp.global(menu))
hl.bind("Menu", hl.dsp.global(menu))

-- ── Productivity ──────────────────────────────────────────────────────────────
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(editor))
hl.bind(mainMod .. " + M", hl.dsp.global(mediaPopup))

-- ── Utilities ─────────────────────────────────────────────────────────────────
hl.bind(mainMod .. " + period", hl.dsp.global(emoji))
hl.bind(mainMod .. " + V", hl.dsp.global("quickshell:clipboardToggle"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- ── Custom scripts ────────────────────────────────────────────────────────────
hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd("~/.config/hypr/scripts/gamemode.sh"))
hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd("~/.config/hypr/scripts/floating.sh"))

-- ══════════════════════════════════════════════════════════════════════════════
--                                WINDOW MANAGEMENT
-- ══════════════════════════════════════════════════════════════════════════════

-- ── Actions ───────────────────────────────────────────────────────────────────
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- ── Focus ─────────────────────────────────────────────────────────────────────
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- ── Mouse ─────────────────────────────────────────────────────────────────────
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ══════════════════════════════════════════════════════════════════════════════
--                                WORKSPACES
-- ══════════════════════════════════════════════════════════════════════════════

-- ── Switch & move (1–10) ──────────────────────────────────────────────────────
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- ── Special workspace ─────────────────────────────────────────────────────────
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + CTRL + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- ── Mouse wheel ───────────────────────────────────────────────────────────────
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- ══════════════════════════════════════════════════════════════════════════════
--                                MEDIA
-- ══════════════════════════════════════════════════════════════════════════════

-- ── Volume ────────────────────────────────────────────────────────────────────
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)

-- ── Brightness ────────────────────────────────────────────────────────────────
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- ── Playback ──────────────────────────────────────────────────────────────────
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind(mainMod .. " + backslash", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind(mainMod .. " + bracketright", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind(mainMod .. " + bracketleft", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- ══════════════════════════════════════════════════════════════════════════════
--                                SCREENSHOTS
-- ══════════════════════════════════════════════════════════════════════════════

hl.bind(
	"PRINT",
	hl.dsp.exec_cmd(
		"hyprshot -z -m output -m $(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name') -o ~/Pictures"
	)
)
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -z -m region -o ~/Pictures"))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("normcap -n True"))

-- ══════════════════════════════════════════════════════════════════════════════
--                                SYSTEM
-- ══════════════════════════════════════════════════════════════════════════════

hl.bind("CTRL + Escape", hl.dsp.exec_cmd("killall qs || qs"))
hl.bind(mainMod .. " + CTRL + Escape", hl.dsp.exec_cmd("wlogout"))
hl.bind(mainMod .. " + Z", hl.dsp.global("quickshell:barHideToggle"))
hl.bind(mainMod .. " + X", hl.dsp.global("quickshell:focusModeToggle"))

hl.bind("SUPER + SHIFT + code:201", hl.dsp.global("quickshell:wallpaperPickerToggle"))
