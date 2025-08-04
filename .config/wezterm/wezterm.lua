local wezterm = require("wezterm")
local fontdefs = require("fonts")
local config = wezterm.config_builder()

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	-- return "Dark"
end

local function scheme_for_appearance(appearance)
	-- color_scheme = "Broadcast"
	if appearance:find("Dark") then
		return "duskfox"
	else
		-- return "Tomorrow Night Eighties"
		-- return "Atelier Plateau Light (base16)"
		-- return "dayfox"
		-- return "flexoki-light"
		return "CYBERDREAM"
	end
end

-- local scheme_colors, _meta = wezterm.color.load_scheme("/Users/james/.config/wezterm/colors/cyberdream-light.toml")

config.font = fontdefs.commit_light
config.font_size = 15
config.line_height = 1.1

config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "EaseInOut"
config.cursor_blink_ease_out = "EaseInOut"
config.default_cursor_style = "BlinkingBar"

config.color_scheme = scheme_for_appearance(get_appearance())
-- config.colors = scheme_colors
-- config.colors = require("custom_colors")

config.window_decorations = "RESIZE"

config.window_background_opacity = 0.9
config.text_background_opacity = 0.3

config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

config.window_content_alignment = {
	horizontal = "Center",
	vertical = "Center",
}

config.initial_cols = 220
config.initial_rows = 70

config.window_frame = {
	font = fontdefs.commit_heavy,
	-- The size of the font in the tab bar.
	font_size = 13.0,

	-- active_titlebar_bg = active_titlebar_bg(get_appearance()),
	-- active_titlebar_fg = active_titlebar_fg(get_appearance()),
	-- inactive_titlebar_bg = inactive_titlebar_bg(get_appearance()),
	-- inactive_titlebar_fg = inactive_titlebar_fg(get_appearance()),

	border_left_width = "0",
	border_right_width = "0",
	border_bottom_height = "0",
	border_top_height = "0",

	-- should not be visible, so use a bold color
	border_left_color = "#ff0000",
	border_right_color = "#ff0000",
	border_bottom_color = "#ff0000",
	border_top_color = "#ff0000",
}

config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.quit_when_all_windows_are_closed = false
config.enable_scroll_bar = true

config.disable_default_key_bindings = false

config.keys = require("keymaps")

-- add improved link rules
config.hyperlink_rules = require("hyperlinks").hyperlink_rules

return config
