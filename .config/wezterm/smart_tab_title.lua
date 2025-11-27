local wezterm = require("wezterm")

local M = {}

-- --- Config knobs you can tweak ------------------------------------------
M.settings = {
	-- How many trailing path segments to show:
	--   1 => "infra"
	--   2 => "codex/infra"
	--   3 => "work/codex/infra"
	max_path_segments = 2,

	-- Treat these procs as "boring" shells (don't show in title)
	boring_procs = {
		zsh = true,
		bash = true,
		fish = true,
	},
}

-- --- Helpers --------------------------------------------------------------

local function basename(path)
	if not path or path == "" then
		return ""
	end
	return path:gsub("(.*[/\\])(.*)", "%2")
end

local function short_hostname(host)
	if not host or host == "" then
		return nil
	end

	-- If it's an IPv4 address, keep it as-is
	if host:match("^%d+%.%d+%.%d+%.%d+$") then
		return host
	end

	-- Otherwise just the first label (foo from foo.bar.baz)
	local first = host:match("^([^.]+)")
	return first or host
end

local function split_path(path)
	local parts = {}
	for part in path:gmatch("[^/]+") do
		table.insert(parts, part)
	end
	return parts
end

local function tail_segments(parts, n)
	local res = {}
	local count = math.min(n, #parts)
	for i = #parts - count + 1, #parts do
		table.insert(res, parts[i])
	end
	return res
end

-- Build host + path context from cwd Url
local function context_from_cwd(cwd, settings)
	if not cwd then
		return nil, nil
	end

	local host = cwd.host
	local path = cwd.file_path or ""

	-- If host matches local machine, treat as local
	local local_host = wezterm.hostname()
	if host == "" or host == local_host then
		host = nil
	end

	-- For local paths, strip $HOME to reduce noise
	if not host then
		local home = wezterm.home_dir
		if path:sub(1, #home) == home then
			path = path:sub(#home + 2) -- drop "$HOME/"
		end
	end

	local parts = split_path(path)
	if #parts == 0 then
		return short_hostname(host), nil
	end

	local max_segments = settings.max_path_segments or 2
	local tail = tail_segments(parts, max_segments)
	local path_ctx = table.concat(tail, "/")

	return short_hostname(host), path_ctx
end

-- --- Main entry point -----------------------------------------------------

function M.format_tab_title(tab, tabs, panes, config, hover, max_width)
	local settings = M.settings
	local pane = tab.active_pane

	-- Foreground process name, simplified
	local proc = pane.foreground_process_name or ""
	proc = basename(proc)
	if proc == "" then
		proc = nil
	end

	if proc and settings.boring_procs[proc] then
		proc = nil
	end

	-- Host + path context (remote-aware via OSC 7)
	local cwd = pane.current_working_dir
	local host, path_ctx = context_from_cwd(cwd, settings)

	local context

	if host and path_ctx and path_ctx ~= "" then
		-- Remote: "<host>: path"
		context = string.format("%s: %s", host, path_ctx)
	elseif host then
		-- Remote, no useful path
		context = host
	else
		-- Local: just the path context
		context = path_ctx
	end

	-- Special-case: if proc matches the first path segment we’re already
	-- showing, don't duplicate it (e.g. codex in .../codex/infra)
	if proc and context and not host then
		local first_seg = context:match("^([^/]+)")
		if first_seg and first_seg == proc then
			proc = nil
		end
	end

	-- Final title assembly
	local title
	if proc and context then
		title = proc .. ": " .. context
	elseif context then
		title = context
	elseif proc then
		title = proc
	else
		title = pane.title
	end

	return " " .. title .. " "
end

return M
