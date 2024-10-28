local wezterm = require("wezterm")
local act = wezterm.action

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	-- return "Dark"
end

local function scheme_for_appearance(appearance)
	-- color_scheme = "Broadcast",
	if appearance:find("Dark") then
		return "duskfox"
	else
		-- return "Tomorrow Night Eighties"
		-- return "Atelier Plateau Light (base16)"
		return "dayfox"
	end
end

-- base00: #f4ecec
-- base01: #e7dfdf
-- base02: #8a8585
-- base03: #7e7777
-- base04: #655d5d
-- base05: #585050
-- base06: #292424
-- base07: #1b1818
-- base08: #ca4949
-- base09: #b45a3c
-- base0A: #a06e3b
-- base0B: #4b8b8b
-- base0C: #5485b6
-- base0D: #7272ca
-- base0E: #8464c4
-- base0F: #bd5187

local function active_titlebar_bg(appearance)
	if appearance:find("Dark") then
		return "#333333"
	else
		return "#f4ecec"
	end
end

local function active_titlebar_fg(appearance)
	if appearance:find("Dark") then
		return "#a06e3b"
	else
		return "#8464c4"
	end
end

local function inactive_titlebar_bg(appearance)
	if appearance:find("Dark") then
		return "#363636"
	else
		return "#e7dfdf"
	end
end

local function inactive_titlebar_fg(appearance)
	if appearance:find("Dark") then
		return "#e7dfdf"
	else
		return "#5485b6"
	end
end

return {
	-- font = wezterm.font("SauceCodePro Nerd Font Mono", { weight = "Light", stretch = "Normal", style = "Normal" }),
	font = wezterm.font({
		family = "Fira Code",
		weight = "Light",
		stretch = "Normal",
		style = "Normal",
		-- https://github.com/tonsky/FiraCode/wiki/How-to-enable-stylistic-sets
		harfbuzz_features = { "zero", "cv02", "cv01", "ss01", "cv14", "ss08", "cv24", "ss06", "cv27", "ss07" },
		-- /= <= >= != -> <- => := ... ++ -- :: // ** /* */ << >> && || ?? ::= \\ [] {. .} =~
	}),

	font_size = 15,

	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10,
	},

	initial_cols = 208,
	initial_rows = 55,

	color_scheme = scheme_for_appearance(get_appearance()),

	cursor_blink_rate = 500,
	cursor_blink_ease_in = "EaseInOut",
	cursor_blink_ease_out = "EaseInOut",
	default_cursor_style = "BlinkingBar",

	window_background_opacity = 0.9,
	text_background_opacity = 0.3,

	window_frame = {
		font = wezterm.font({
			family = "Fira Code Retina",
			-- weight = "450", -- retina
			stretch = "Normal",
			style = "Normal",
			-- https://github.com/tonsky/FiraCode/wiki/How-to-enable-stylistic-sets
			harfbuzz_features = { "zero", "cv02", "cv01", "ss01", "cv14", "ss08", "cv24", "ss06", "cv27", "ss07" },
			-- /= <= >= != -> <- => := ... ++ -- :: // ** /* */ << >> && || ?? ::= \\ [] {. .} =~
		}),

		-- The size of the font in the tab bar.
		-- Default to 10. on Windows but 12.0 on other systems
		font_size = 13.0,

		active_titlebar_bg = active_titlebar_bg(get_appearance()),
		active_titlebar_fg = active_titlebar_fg(get_appearance()),

		inactive_titlebar_bg = inactive_titlebar_bg(get_appearance()),
		inactive_titlebar_fg = inactive_titlebar_fg(get_appearance()),

		border_left_width = "0",
		border_right_width = "0",
		border_bottom_height = "0",
		border_top_height = "0",

		border_left_color = "#ca4949",
		border_right_color = "#ca4949",
		border_bottom_color = "#ca4949",
		border_top_color = "#ca4949",
	},

	colors = {
		tab_bar = {
			-- The active tab is the one that has focus in the window
			active_tab = {
				bg_color = active_titlebar_bg(get_appearance()),
				fg_color = active_titlebar_fg(get_appearance()),

				intensity = "Normal",
				underline = "Single",
				italic = false,
				strikethrough = false,
			},
			inactive_tab = {
				bg_color = inactive_titlebar_bg(get_appearance()),
				fg_color = inactive_titlebar_fg(get_appearance()),

				intensity = "Normal",
				underline = "None",
				italic = false,
				strikethrough = false,
			},
			-- The new tab button that let you create new tabs
			new_tab = {
				bg_color = active_titlebar_bg(get_appearance()),
				fg_color = "#ca4949",

				-- The same options that were listed under the `active_tab` section above
				-- can also be used for `new_tab`.
			},
			-- The color of the inactive tab bar edge/divider
			inactive_tab_edge = "#8a8585",
		},
	},

	use_fancy_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	quit_when_all_windows_are_closed = false,
	enable_scroll_bar = true,

	disable_default_key_bindings = false,

	keys = {
		{ key = "d", mods = "CMD|OPT", action = act.ShowDebugOverlay },
		{ key = "r", mods = "CMD|OPT", action = act.ReloadConfiguration },

		{ key = "k", mods = "CMD", action = act.ClearScrollback("ScrollbackAndViewport") },

		{ key = "q", mods = "CMD", action = act.QuitApplication },
		{ key = "w", mods = "CMD", action = act.CloseCurrentTab({ confirm = true }) },
		{ key = "n", mods = "CMD", action = act.SpawnWindow },
		{ key = "t", mods = "CMD", action = act.SpawnTab("DefaultDomain") },

		{ key = "1", mods = "CMD", action = act.ActivateTab(0) },
		{ key = "2", mods = "CMD", action = act.ActivateTab(1) },
		{ key = "3", mods = "CMD", action = act.ActivateTab(2) },
		{ key = "4", mods = "CMD", action = act.ActivateTab(4) },
		{ key = "5", mods = "CMD", action = act.ActivateTab(5) },
		{ key = "6", mods = "CMD", action = act.ActivateTab(6) },
		{ key = "7", mods = "CMD", action = act.ActivateTab(7) },
		{ key = "8", mods = "CMD", action = act.ActivateTab(8) },
		{ key = "9", mods = "CMD", action = act.ActivateTab(9) },

		{ key = "LeftArrow", mods = "CMD", action = act.ActivateTabRelative(-1) },
		{ key = "RightArrow", mods = "CMD", action = act.ActivateTabRelative(1) },
		{ key = "{", mods = "CMD|SHIFT", action = act.ActivateTabRelative(-1) },
		{ key = "}", mods = "CMD|SHIFT", action = act.ActivateTabRelative(1) },

		{ key = "Enter", mods = "CMD|SHIFT", action = act.ToggleFullScreen },

		{ key = "=", mods = "CMD", action = act.IncreaseFontSize },
		{ key = "-", mods = "CMD", action = act.DecreaseFontSize },
		{ key = "0", mods = "CMD", action = act.ResetFontSize },

		{ key = "c", mods = "CMD", action = act.CopyTo("Clipboard") },
		{ key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },
		-- { key = 'x', mods = 'CMD', action = act.ActivateCopyMode },
		-- { key = 'f', mods = 'CMD', action = act.Search 'CurrentSelectionOrEmptyString' },
		-- { key = 'e', mods = 'CMD', action = act.CharSelect{ copy_on_select = true, copy_to =  'ClipboardAndPrimarySelection' } },
		-- { key = 'Insert', mods = 'SHIFT', action = act.PasteFrom 'PrimarySelection' },
		-- { key = 'Insert', mods = 'CTRL', action = act.CopyTo 'PrimarySelection' },
	},
}
