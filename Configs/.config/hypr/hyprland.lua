-- Hyprland loads this file when it is started without a config, and it prefers
-- it over hyprland.conf. HyDE loads it too, last, as the override layer below.
-- The block keeps the two apart: hyde.lua sets `hyde` on its first line, so it
-- runs only when this file is the entry point and HyDE has not been loaded.
-- Removing it leaves a session with a cursor and nothing else.
if not hyde then
	local share = os.getenv("XDG_DATA_HOME") or (os.getenv("HOME") .. "/.local/share")
	local entry = share .. "/hypr/hyde.lua"
	local handle = io.open(entry, "r")
	if not handle then
		error("HyDE is not installed at " .. entry .. ". Run install.sh -r, or point Hyprland at your own config.")
	end
	handle:close()
	dofile(entry)
end

-- Your Hyprland configuration. HyDE never overwrites this file.
--
-- It loads after HyDE's own binds, so settings here take precedence. Replacing
-- a bind needs more than that: see below. HyDE's defaults live in
-- ~/.local/share/hypr/lua/ and are overwritten on every update, so edits there
-- do not survive.
--
-- Adding a keybind:
--
--     hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(hyde.sh.gamelauncher()), {
--         description = "[Utilities] game launcher",
--     })
--
-- Replacing one of HyDE's: bind the same combination again and yours takes
-- over, but copy its flags across as well. A bind counts as the same one only
-- when its flags match, and `description` is not a flag — miss one and both
-- binds stay live on that combination. Copy the whole options table from
-- ~/.local/share/hypr/lua/key_binds.lua and change only what you need:
--
--     hl.bind("F9", hl.dsp.exec_cmd(hyde.sh.volumecontrol("-o", "m")), {
--         locked = true,
--         description = "[Hardware Controls|Audio] un/mute output",
--     })
--
-- Press SUPER + / to see what is actually loaded, your own binds included.
-- The full reference is KEYBINDINGS.md in the HyDE repository.
--
-- Other Lua files next to this one can be pulled in with require("name").

-- Ported from the pre-Lua .conf files (monitors.conf, userprefs.conf,
-- nvidia.conf, keybindings.conf, themes/theme.conf) during the upstream
-- Lua-config migration. See MIGRATION-LUA.md.

-- monitors.conf
hl.monitor({ output = "DP-1", mode = "2560x1440@144", position = "0x0", scale = 1, vrr = 1, bitdepth = 10 })
hl.monitor({ output = "DP-2", mode = "5120x1440@240", position = "-1280x1440", scale = 1, vrr = 1, bitdepth = 10 })
hl.monitor({ output = "HDMI-A-1", disabled = true })

-- nvidia.conf: may help with Electron apps under Wayland+NVIDIA
hl.env("NVD_BACKEND", "direct")

-- userprefs.conf
hl.permission({ binary = "/usr/(bin|local/bin)/hyprpm", type = "plugin", mode = "allow" })

hl.on("hyprland.start", function()
	hl.exec_cmd("hyprpm reload -n")
	hl.exec_cmd("protonvpn-app")
	hl.exec_cmd("steam -silent")
	hl.exec_cmd("coolercontrol")
	hl.exec_cmd("sunshine")

	-- ponytail: split-monitor-workspaces has no typed Lua config API yet, so
	-- its plugin: namespace is set the same way hyprpm/hyprlang always did it,
	-- via the generic hyprctl keyword escape hatch. Verify with `hyprctl
	-- plugin list` after a plugin update if these silently stop applying.
	hl.exec_cmd("hyprctl keyword plugin:split-monitor-workspaces:count 5")
	hl.exec_cmd("hyprctl keyword plugin:split-monitor-workspaces:keep_focused 0")
	hl.exec_cmd("hyprctl keyword plugin:split-monitor-workspaces:enable_notifications 0")
	hl.exec_cmd("hyprctl keyword plugin:split-monitor-workspaces:enable_persistent_workspaces 1")
	hl.exec_cmd("hyprctl keyword plugin:wslayout:default_layout dwindle")
end)

hl.config({
	input = { kb_layout = "de,us" },
	master = {
		new_status = "inherit", -- slave
		mfact = 0.5,
		orientation = "center",
		slave_count_for_center_master = 0,
		new_on_top = true,
	},
	layout = { single_window_aspect_ratio = "16 9" },
	general = { layout = "dwindle" },
	misc = {
		enable_swallow = true,
		swallow_regex = "(foot|kitty|allacritty|Alacritty|ghostty|Ghostty|WezTerm|org.wezfurlong.wezterm)",
	},
	ecosystem = { no_update_news = true },
})

-- Unreal Engine 5 window fix, from userprefs.conf
hl.window_rule({
	name = "unreal-editor-fix",
	match = { class = "UnrealEditor" },
	no_initial_focus = true,
	suppress_event = "activate",
	no_anim = true,
	no_blur = true,
	no_shadow = true,
	group = "deny",
	opacity = 1.0,
})

-- themes/theme.conf: HyDE blurs waybar by default (hyde_layer_blur); undo
-- just that one namespace, evaluated after HyDE's own rule so it wins.
hl.layer_rule({
	name = "user_no_waybar_blur",
	match = { namespace = "waybar" },
	blur = false,
})

-- keybindings.conf: move the app finder off SUPER+A
hl.unbind("SUPER + A")
hl.bind("ALT + SPACE", hl.dsp.exec_cmd(hyde.sh.menu.apps()), {
	description = "[Launcher|Rofi menus] application finder",
})

-- keybindings.conf: workspaces 1-5 route through split-monitor-workspaces.
-- Same caveat as the plugin config above: no typed hl.dsp helper exists for
-- these plugin dispatchers, so they go through the raw-dispatcher escape
-- hatch. Test SUPER+1..5 land on the right monitor after reload.
for i = 1, 5 do
	hl.unbind("SUPER + " .. i)
	hl.bind("SUPER + " .. i, hl.dsp.exec_raw("split-workspace", tostring(i)), {
		description = "[Workspaces|Navigation] navigate to workspace " .. i,
	})
	hl.unbind("SUPER + SHIFT + " .. i)
	hl.bind("SUPER + SHIFT + " .. i, hl.dsp.exec_raw("split-movetoworkspace", tostring(i)), {
		description = "[Workspaces|Move window to workspace] move focused window to workspace " .. i,
	})
	hl.unbind("SUPER + ALT + " .. i)
	hl.bind("SUPER + ALT + " .. i, hl.dsp.exec_raw("split-movetoworkspacesilent", tostring(i)), {
		description = "[Workspaces|Move window (Don't follow)] move focused window to workspace " .. i,
	})
end
hl.unbind("SUPER + CONTROL + RIGHT")
hl.bind("SUPER + CONTROL + RIGHT", hl.dsp.exec_raw("split-workspace", "r+1"), {
	description = "[Workspaces|Navigation|Relative workspace] change active workspace forwards",
})
hl.unbind("SUPER + CONTROL + LEFT")
hl.bind("SUPER + CONTROL + LEFT", hl.dsp.exec_raw("split-workspace", "r-1"), {
	description = "[Workspaces|Navigation|Relative workspace] change active workspace backwards",
})
hl.unbind("SUPER + CONTROL + DOWN")
hl.bind("SUPER + CONTROL + DOWN", hl.dsp.exec_raw("split-workspace", "empty"), {
	description = "[Workspaces|Navigation] navigate to the nearest empty workspace",
})
hl.unbind("SUPER + mouse_down")
hl.bind("SUPER + mouse_down", hl.dsp.exec_raw("split-workspace", "e+1"), {
	description = "[Workspaces|Navigation|Mouse] next workspace",
})
hl.unbind("SUPER + mouse_up")
hl.bind("SUPER + mouse_up", hl.dsp.exec_raw("split-workspace", "e-1"), {
	description = "[Workspaces|Navigation|Mouse] previous workspace",
})
hl.unbind("SUPER + SHIFT + S")
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_raw("split-movetoworkspace", "special"), {
	description = "[Workspaces|Navigation|Special workspace] move focused window to scratchpad",
})
