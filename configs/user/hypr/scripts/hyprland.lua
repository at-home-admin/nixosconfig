-- Hyprland Lua Configuration
-- Targets Hyprland v0.55+

-- =========================================================================
-- Variables & Programs
-- =========================================================================
local terminal = "kitty"
local browser = "zen"
local volume = "pavucontrol"
local mainMod = "SUPER"

-- =========================================================================
-- Monitors
-- =========================================================================
hyprland.monitor = {
	"eDP-1, 1920x1080@60.00800, 0x0, 1.00",
}

-- =========================================================================
-- Auto-Start (exec-once)
-- =========================================================================
hyprland["exec-once"] = {
	"wpaperd &",
	"systemctl --user start hyprpolkitagent",
	"nm-applet --indicator &",
	"waybar",
	"mako",
	"exec xrdb -load ~/.Xresources",
	"wl-paste --type text --watch cliphist store",
	"wl-paste --type image --watch cliphist store",
	".config/hypr/exec-hyprland",
}

-- =========================================================================
-- General Configuration Blocks
-- =========================================================================
hyprland.input = {
	kb_layout = "us",
	kb_variant = "",
	kb_model = "",
	kb_options = "",
	kb_rules = "",
	numlock_by_default = true,
	follow_mouse = 1,
	sensitivity = 0,

	touchpad = {
		natural_scroll = true,
		tap_to_click = true,
		disable_while_typing = true,
	},
}

hyprland.general = {
	gaps_in = 5,
	gaps_out = 10,
	border_size = 2,
	["col.active_border"] = "rgba(33ccffee) rgba(8f00ffee) 45deg",
	["col.inactive_border"] = "rgba(595959aa)",
	layout = "dwindle",
}

hyprland.animations = {
	enabled = true,
	bezier = {
		"myBezier, 0.05, 0.9, 0.1, 1.05",
	},
	animation = {
		"windows, 1, 7, myBezier",
		"windowsOut, 1, 7, default, popin 80%",
		"border, 1, 10, default",
		"fade, 1, 7, default",
		"workspaces, 1, 6, default",
	},
}

hyprland.dwindle = {
	pseudotile = true,
	preserve_split = true,
}

hyprland.misc = {
	disable_hyprland_logo = false,
}

-- =========================================================================
-- Layer Rules & Blur
-- =========================================================================
hyprland.layerrule = {
	"blur, waybar",
	"ignorezero, waybar",
}

hyprland.blurls = {
	"wofi",
	"thunar",
	"gedit",
	"gtk-layer-shell",
	"catfish",
}

-- =========================================================================
-- Window Rules (v2)
-- =========================================================================
hyprland.windowrulev2 = {
	"opacity 0.85 0.85, floating:1",
	"float, class:^(one.alynx.showmethekey)$",
	"float, class:^(showmethekey-gtk)$",
	"pin, class:^(showmethekey-gtk)$",
	"size 100% 5%, class:^(one.alynx.showmethekey)$",
	"move 0% 95%, class:^(one.alynx.showmethekey)$",
	"noborder, class:^(one.alynx.showmethekey)$",
}

-- =========================================================================
-- Keybindings (Binds)
-- =========================================================================
hyprland.bind = {
	-- Core System Shortcuts
	mainMod .. ", return, exec, " .. terminal,
	mainMod .. " SHIFT, R, exec, hyprctl reload",
	mainMod .. ", Q, killactive,",
	mainMod .. " SHIFT, E, exec, nwgbar",
	mainMod .. " SHIFT, N, exec, thunar",
	mainMod .. " SHIFT, 65, togglefloating,",
	mainMod .. ", P, pseudo,",
	mainMod .. " SHIFT, P, togglesplit,",
	mainMod .. ", F, fullscreen",

	-- Custom Application Launches
	mainMod .. ", D, exec, wofi --normal-window --show drun --allow-images",
	mainMod .. " SHIFT, D, exec, nwg-drawer -mb 10 -mr 10 -ml 10 -mt 10",
	mainMod .. ", C, exec, env MOZ_ENABLE_WAYLAND=1 " .. browser,
	mainMod .. ", N, exec, " .. terminal .. " --hold --directory /home/bfoster/config -e tv",
	mainMod .. ", W, exec, warp-terminal",
	mainMod .. ", K, exec, showmethekey-gtk -k -A",
	mainMod .. ", O, exec, firedragon",
	mainMod .. " SHIFT, C, exec, killall -9 wpaperd && wpaperd &",
	mainMod .. ", V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy",

	-- Move focus with mainMod + arrow / hjkl keys
	mainMod .. ", left, movefocus, l",
	mainMod .. ", h, movefocus, l",
	mainMod .. ", right, movefocus, r",
	mainMod .. ", l, movefocus, r",
	mainMod .. ", up, movefocus, u",
	mainMod .. ", k, movefocus, u",
	mainMod .. ", down, movefocus, d",
	mainMod .. ", j, movefocus, d",

	-- Move windows with mainMod + SHIFT + arrow / hjkl keys
	mainMod .. " SHIFT, up, movewindow, u",
	mainMod .. " SHIFT, K, movewindow, u",
	mainMod .. " SHIFT, down, movewindow, d",
	mainMod .. " SHIFT, J, movewindow, d",
	mainMod .. " SHIFT, left, movewindow, l",
	mainMod .. " SHIFT, H, movewindow, l",
	mainMod .. " SHIFT, right, movewindow, r",
	mainMod .. " SHIFT, L, movewindow, r",

	-- Hardware & Media Controls
	", 122, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%",
	", 123, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%",
	", 121, exec, pactl set-sink-volume @DEFAULT_SINK@ 0%",
	", 232, exec, brightnessctl -c backlight set 5%-",
	", 233, exec, brightnessctl -c backlight set +5%",
	", 172, exec, playerctl play-pause",
	", 171, exec, playerctl next",
	", 173, exec, playerctl previous",

	-- Screenshots via Grim & Slurp
	', Print, exec, grim -g "$(slurp)" - | swappy -f -',
	"CTRL, Print, exec, .config/hypr/scripts/screenshot_window.sh",
	"SHIFT, Print, exec, .config/hypr/scripts/screenshot_display.sh",

	-- Mouse Scroll Workspaces
	mainMod .. ", mouse_down, workspace, e+1",
	mainMod .. ", mouse_up, workspace, e-1",
}

-- Workspace Switch Loops (1 to 10)
for i = 1, 9 do
	table.insert(hyprland.bind, mainMod .. ", " .. i .. ", workspace, " .. i)
	table.insert(hyprland.bind, "ALT SHIFT, " .. i .. ", movetoworkspace, " .. i)
	table.insert(hyprland.bind, mainMod .. " SHIFT, " .. i .. ", movetoworkspacesilent, " .. i)
end
-- Handle 0 mapping to Workspace 10
table.insert(hyprland.bind, mainMod .. ", 0, workspace, 10")
table.insert(hyprland.bind, "ALT SHIFT, 0, movetoworkspace, 10")
table.insert(hyprland.bind, mainMod .. " SHIFT, 0, movetoworkspacesilent, 10")

-- =========================================================================
-- Mouse Bindings (bindm)
-- =========================================================================
hyprland.bindm = {
	mainMod .. ", mouse:272, movewindow",
	mainMod .. ", mouse:273, resizewindow",
}

-- =========================================================================
-- Submaps (Resize Mode)
-- =========================================================================
-- Trigger entering the resize submap
table.insert(hyprland.bind, mainMod .. ", R, submap, resize")

hyprland.submap = {
	resize = {
		binde = {
			", right, resizeactive, 50 0",
			", L, resizeactive, 50 0",
			", left, resizeactive, -50 0",
			", H, resizeactive, -50 0",
			", up, resizeactive, 0 -50",
			", K, resizeactive, 0 -50",
			", down, resizeactive, 0 50",
			", J, resizeactive, 0 50",
		},
		bind = {
			", escape, submap, reset",
			", catchall, submap, reset",
		},
	},
}
