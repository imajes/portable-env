-- Deliver standard mode-2031 reports to explicitly listening shell line editors.
-- WezTerm currently answers color queries but does not implement mode 2031.
local wezterm = require("wezterm")
local M = {}
local variable = "LAB_TERMINAL_NOTIFY"

local function current_mode(window)
	local config = window:effective_config()
	local palette = config.resolved_palette
	if not palette then
		palette = (config.color_schemes or {})[config.color_scheme]
			or wezterm.color.get_builtin_schemes()[config.color_scheme]
	end
	local background = (config.colors or {}).background or (palette or {}).background
	if not background then
		return nil
	end
	local _, _, lightness = wezterm.color.parse(background):hsla()
	return lightness < 0.5 and 1 or 2
end

function M.update(window, pane)
	-- Read current state, not a possibly stale queued event argument. The shell
	-- clears it before launching a command. Unmodified shells never opt in.
	local listener = pane:get_user_vars()[variable]
	if listener ~= "1" and listener ~= "tmux" then
		return
	end
	local mode = current_mode(window)
	if mode then
		pane:send_text("\x1b[?997;" .. mode .. "n")
	end
end

function M.setup()
	wezterm.on("user-var-changed", function(window, pane, name)
		if name == variable then
			M.update(window, pane)
		end
	end)
	wezterm.on("window-config-reloaded", function(window)
		for _, tab in ipairs(window:mux_window():tabs()) do
			for _, pane in ipairs(tab:panes()) do
				M.update(window, pane)
			end
		end
	end)
end

return M
