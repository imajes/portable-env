-- functions and behaviors to control color settings

local wezterm = require("wezterm")

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
		-- return "flexoki-light"
	end
end

-- flexoki-light colors: https://stephango.com/flexoki

local function active_titlebar_bg(appearance)
	if appearance:find("Dark") then
		return "#333333"
	else
		-- return "rgb(242, 240, 229)"
		return "rgb(218, 216, 206)"
	end
end

-- unused
local function active_titlebar_fg(appearance)
	if appearance:find("Dark") then
		return "#a06e3b"
	else
		return "rgb(206, 93, 151)"
	end
end

local function inactive_titlebar_bg(appearance)
	if appearance:find("Dark") then
		return "#363636"
	else
		return "rgb(218, 216, 206)"
	end
end

-- unused
local function inactive_titlebar_fg(appearance)
	if appearance:find("Dark") then
		return "#e7dfdf"
	else
		return "rgb(206, 93, 151)"
	end
end

local function active_tab_bg(appearance)
	if appearance:find("Dark") then
		return "#333333"
	else
		return "rgb(58, 169, 159)"
	end
end

local function active_tab_fg(appearance)
	if appearance:find("Dark") then
		return "#a06e3b"
	else
		return "#fffcf0"
	end
end

local function inactive_tab_bg(appearance)
	if appearance:find("Dark") then
		return "#363636"
	else
		return "rgb(218, 216, 206)"
	end
end

local function inactive_tab_fg(appearance)
	if appearance:find("Dark") then
		return "#e7dfdf"
	else
		return "#100f0f"
	end
end

local function new_tab_button_bg(appearance)
	if appearance:find("Dark") then
		return "#363636"
	else
		return "rgb(255, 252, 240)"
	end
end

local function new_tab_button_fg(appearance)
	if appearance:find("Dark") then
		return "#e7dfdf"
	else
		return "rgb(175, 48, 41)"
	end
end

local function inactive_tab_edge(appearance)
	if appearance:find("Dark") then
		return "#e7dfdf"
	else
		-- return "rgb(111, 110, 105)"
		return "rgb(242, 240, 229)"
	end
end

return {
	tab_bar = {
		-- The active tab is the one that has focus in the window
		active_tab = {
			bg_color = active_tab_bg(get_appearance()),
			fg_color = active_tab_fg(get_appearance()),

			intensity = "Bold",
			underline = "Single",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = inactive_tab_bg(get_appearance()),
			fg_color = inactive_tab_fg(get_appearance()),

			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = true,
		},
		-- The new tab button that let you create new tabs
		new_tab = {
			bg_color = new_tab_button_bg(get_appearance()),
			fg_color = new_tab_button_fg(get_appearance()),

			intensity = "Bold",
			underline = "None",
			italic = false,
			strikethrough = true,
		},
		-- The color of the inactive tab bar edge/divider
		inactive_tab_edge = inactive_tab_edge(get_appearance()),
	},
}
