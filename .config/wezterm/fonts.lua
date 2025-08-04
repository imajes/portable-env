local wezterm = require("wezterm")

-- https://github.com/tonsky/FiraCode/wiki/How-to-enable-stylistic-sets
-- harfbuzz_features = { "+cv05", "+cv08", "+cv09", "+ss01", "+ss02", "+ss03", "+ss04", "+ss05" },
-- /= <= >= != -> <- => := ... ++ -- :: // ** /* */ << >> && || ?? ::= \\ [] {. .} =~

return {
	commit_light = wezterm.font({
		family = "CommitMono",
		weight = 225,
		stretch = "Normal",
		style = "Normal",
		harfbuzz_features = { "+cv05", "+cv08", "+cv09", "+ss01", "+ss02", "+ss03", "+ss04", "+ss05" },
	}),

	commit_heavy = wezterm.font({
		family = "CommitMono",
		weight = 500,
		stretch = "Normal",
		style = "Normal",
		harfbuzz_features = { "+cv05", "+cv08", "+cv09", "+ss01", "+ss02", "+ss03", "+ss04", "+ss05" },
	}),

	fira_light = wezterm.font({
		family = "Fira Code",
		weight = "Light",
		stretch = "Normal",
		style = "Normal",
		harfbuzz_features = { "zero", "cv02", "cv01", "ss01", "cv14", "ss08", "cv24", "ss06", "cv27", "ss07" },
	}),

	fira_normal = wezterm.font({
		family = "Fira Code",
		-- weight = "450", -- retina
		stretch = "Normal",
		style = "Normal",
		harfbuzz_features = { "zero", "cv02", "cv01", "ss01", "cv14", "ss08", "cv24", "ss06", "cv27", "ss07" },
	}),
}
