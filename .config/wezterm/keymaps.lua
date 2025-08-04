local act = require("wezterm").action

return {
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
}
