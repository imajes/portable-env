local wezterm = require("wezterm")
local config = {}

-- Function to find GitHub org/repo from current working directory
local function github_repo_from_git_dir(cwd)
	local git_dir = cwd and cwd:sub(8) -- strip "file://" prefix
	if not git_dir then
		return nil
	end

	-- Try to get the GitHub remote URL
	local handle = io.popen('cd "' .. git_dir .. '" && git config --get remote.origin.url 2>/dev/null')
	if not handle then
		return nil
	end

	local url = handle:read("*a")
	handle:close()
	if not url or url == "" then
		return nil
	end

	-- Normalize URL
	-- Examples:
	-- git@github.com:org/repo.git
	-- https://github.com/org/repo.git
	local org_repo = url:match("github.com[:/](.-)%.git")
	return org_repo
end

-- Use the defaults as a base
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- make task numbers clickable
-- the first matched regex group is captured in $1.
table.insert(config.hyperlink_rules, {
	regex = [[\b[tt](\d+)\b]],
	format = "https://example.com/tasks/?t=$1",
})

-- make username/project paths clickable. this implies paths like the following are for github.
-- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wezterm/wezterm | "wezterm/wezterm.git" )
-- as long as a full url hyperlink regex exists above this it should not match a full url to
-- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)
table.insert(config.hyperlink_rules, {
	regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
	format = "https://www.github.com/$1/$3",
})

-- TODO: This is disabled currently because it doesn't actually work yet(?) in wezterm
-- Rule: match 7–40 char SHA (hex), optionally anchored by word boundaries
-- Regex groups the SHA as $1. You could constrain to your own SHA length.
-- table.insert(config.hyperlink_rules, {
-- 	regex = [[\b([0-9a-f]{7,40})\b]],
-- 	format = function(window, pane, match)
-- 		local org_repo = github_repo_from_git_dir(pane:get_current_working_dir())
-- 		if org_repo then
-- 			return "https://github.com/" .. org_repo .. "/commit/" .. match
-- 		end
-- 		return nil
-- 	end,
-- 	highlight = 1, -- underline only the SHA
-- })

-- NOTE: this version uses an env var, however it's only ever relevant on first boot, so it's.. useless.
-- Rule: match 7–40 char SHA (hex), optionally anchored by word boundaries
-- Regex groups the SHA as $1. You could constrain to your own SHA length.
-- table.insert(config.hyperlink_rules, {
-- 	regex = [[\b([0-9a-f]{7,40})\b]],
-- 	format = os.getenv("GITHUB_REPO") and ("https://github.com/" .. os.getenv("GITHUB_REPO") .. "/commit/$1")
-- 		or "https://github.com/$1",
-- 	highlight = 1, -- underline only the SHA
-- })

-- Rule: match 7–40 char SHA (hex), optionally anchored by word boundaries
-- Regex groups the SHA as $1. You could constrain to your own SHA length.
table.insert(config.hyperlink_rules, {
	regex = [[\b([0-9a-f]{7,40})\b]],
	format = "https://github.com/citizenobserver/tip411-web/commit/$1",
	highlight = 1, -- underline only the SHA
})
return config
