-- ~/.config/wezterm/fonts.lua
local wezterm = require("wezterm")

-- Stylistic sets
local commit_features = { "+cv05", "+cv08", "+cv09", "+ss01", "+ss02", "+ss03", "+ss04", "+ss05" }
local fira_features = { "zero", "cv02", "cv01", "ss01", "cv14", "ss08", "cv24", "ss06", "cv27", "ss07" }

-- ===== CommitMono faces (locals only; no rules yet) =====
local commit_light = wezterm.font({
	family = "CommitMono",
	weight = 225,
	stretch = "Normal",
	style = "Normal",
	harfbuzz_features = commit_features,
})

local commit_light_italic = wezterm.font({
	family = "CommitMono",
	weight = 225,
	stretch = "Normal",
	style = "Italic",
	harfbuzz_features = commit_features,
})

local commit_heavy = wezterm.font({
	family = "CommitMono",
	weight = 500,
	stretch = "Normal",
	style = "Normal",
	harfbuzz_features = commit_features,
})

-- IMPORTANT NOTE. this DOES NOT WORK. Saving it for reference.
local commit_heavy_fb = wezterm.font_with_fallback({
	family = "CommitMono",
	style = "Normal",
	stretch = "Normal",
	weight = 500,
	harfbuzz_features = commit_features,
}, {
	foreground = "tomato",
})

local commit_heavy_italic = wezterm.font({
	family = "CommitMono",
	weight = 500,
	stretch = "Normal",
	style = "Italic",
	harfbuzz_features = commit_features,
})

local commit_bold = wezterm.font({
	family = "CommitMono",
	weight = 650,
	stretch = "Normal",
	style = "Normal",
	harfbuzz_features = commit_features,
})

local commit_bold_italic = wezterm.font({
	family = "CommitMono",
	weight = 650,
	stretch = "Normal",
	style = "Italic",
	harfbuzz_features = commit_features,
})

local fira_light = wezterm.font({
	family = "Fira Code",
	weight = "Light",
	stretch = "Normal",
	style = "Normal",
	harfbuzz_features = fira_features,
})
local fira_normal = wezterm.font({
	family = "Fira Code",
	stretch = "Normal",
	style = "Normal",
	harfbuzz_features = fira_features,
})

-- ===== Export base + rules + handles =====
return {
	-- Default face for regular text
	base_font = wezterm.font_with_fallback(fira_light),

	font_rules = {
		-- 1) When Intensity=Bold Italic=false:
		{
			intensity = "Bold",
			italic = false,
			font = commit_heavy,
		},

		-- 2) When Intensity=Bold Italic=true:
		{
			intensity = "Bold",
			italic = true,
			font = commit_bold_italic,
		},

		-- 3) When Intensity=Normal Italic=true:
		{
			intensity = "Normal",
			italic = true,
			font = commit_heavy_italic, -- slightly lighter than bold, still readable
		},

		-- 4) When Intensity=Half Italic=true:
		{
			intensity = "Half",
			italic = true,
			font = commit_light_italic,
		},

		-- 5) When Intensity=Half Italic=false:
		{
			intensity = "Half",
			italic = false,
			font = commit_light,
		},

		-- 6) When Intensity=Half Italic=true: (duplicate mapping, intentional)
		{
			intensity = "Half",
			italic = true,
			font = commit_light_italic,
		},
	},

	-- Expose handles for ad-hoc use elsewhere
	commit_light = commit_light,
	commit_light_italic = commit_light_italic,
	commit_heavy = commit_heavy,
	commit_heavy_italic = commit_heavy_italic,
	commit_bold = commit_bold,
	commit_bold_italic = commit_bold_italic,

	fira_light = fira_light,
	fira_normal = fira_normal,
}

--  vim: set ft=lua ts=2 sw=2 tw=0 et :
