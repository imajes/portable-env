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
		ssh = true,
	},

	-- These procs manage their own terminal title well enough that this helper
	-- should not override it. Codex uses live OSC title updates for useful state.
	passthrough_title_procs = {
		codex = true,
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

-- Build host + path context from cwd (Url object or string)
local function context_from_cwd(cwd, settings)
	if not cwd then
		return nil, nil
	end

	-- In modern wezterm, PaneInformation.current_working_dir is a Url
	-- userdata with .host and .file_path/.path. In some cases (older
	-- versions or other helpers) it may be a string like "file://host/path".
	local host
	local path = ""

	if type(cwd) == "string" then
		-- Try to parse a string URI via wezterm.url.parse if available.
		local parsed
		if wezterm.url and wezterm.url.parse then
			local ok, url = pcall(wezterm.url.parse, cwd)
			if ok and url then
				parsed = url
			end
		end
		-- If parsing failed, bail out rather than throwing.
		if not parsed then
			return nil, nil
		end
		cwd = parsed
	end

	-- At this point we expect a Url-like object (userdata or table)
	host = cwd.host or ""
	path = cwd.file_path or cwd.path or ""

	-- If host matches local machine, treat as local
	local local_host = wezterm.hostname()
	if host == "" or host == local_host then
		host = nil
	end

	-- For local paths, strip $HOME to reduce noise
	if not host then
		local home = wezterm.home_dir
		if home and home ~= "" and path:sub(1, #home) == home then
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

	-- Foreground process name, simplified. Keep both the raw proc and display proc:
	-- raw_proc is used for behavior decisions, display_proc is used in our title.
	local raw_proc = pane.foreground_process_name or ""
	raw_proc = basename(raw_proc)
	if raw_proc == "" then
		raw_proc = nil
	end

	-- Some tools intentionally update the terminal title themselves. For those,
	-- preserve the tool's live title instead of replacing it with cwd/proc context.
	if raw_proc and settings.passthrough_title_procs[raw_proc] then
		local title = pane.title
		if title and title ~= "" then
			return " " .. title .. " "
		end
	end

	local proc = raw_proc
	if proc and settings.boring_procs[proc] then
		proc = nil
	end

	-- Host + path context (remote-aware via OSC 7)
	local cwd = pane.current_working_dir
	local host, path_ctx = context_from_cwd(cwd, settings)

	-- Guard against stale remote OSC 7 state after leaving ssh. While actually
	-- connected, the local foreground process is normally ssh. After ssh exits,
	-- the foreground process returns to a local shell, but current_working_dir may
	-- still contain the last remote host/path until the shell emits a fresh OSC 7.
	if host and raw_proc and settings.boring_procs[raw_proc] and raw_proc ~= "ssh" then
		host = nil
		path_ctx = nil
	end

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
