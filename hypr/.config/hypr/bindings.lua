hl.unbind("SUPER + SHIFT + G")
hl.unbind("SUPER + SHIFT + C")

o.bind("SUPER + E", "File manager", { launch = "nautilus --new-window" })
o.bind("SUPER + Y", "Yazi", { tui = "yazi" })
o.bind("SUPER + SHIFT + V", "Vi Mongo", "uwsm-app -- xdg-terminal-exec vi-mongo")
o.bind("SUPER + SHIFT + G", "Git", { tui = "lazygit" })
o.bind("SUPER + SHIFT + C", "VS Code", { launch = "code" })

-- Treat VS Code as a terminal so SUPER+C/V send Ctrl/Shift+Insert (works in
-- editor and integrated terminal) instead of Ctrl+C/V (SIGINT in terminal).
o.window("code", { tag = "+terminal" })

local hs = dofile(os.getenv("HOME") .. "/.config/hypr/hyprsplit/init.lua")

local ACER = "Acer Technologies X32 V2 15380001D3900"
local LG = "LG Electronics LG ULTRAFINE 308NTYT8W962"
local LAPTOP = "eDP-2"

hs.config({ num_workspaces = 10 })
hs.monitor_priority({ ACER, LG, LAPTOP })

-- nil when the monitor is off (closed lid) or unplugged, so its keys no-op
-- instead of hijacking whichever monitor happens to be focused.
local function monitor(selector)
	for _, m in ipairs(hl.get_monitors()) do
		if m.id ~= -1 and (m.name == selector or m.description == selector) then
			return m
		end
	end
	return nil
end

local function focus_workspace(selector, workspace)
	return function()
		local m = monitor(selector)
		if m then
			hl.dispatch(hl.dsp.focus({ monitor = m }))
			hs.dsp.focus({ workspace = workspace })()
		end
	end
end

local function move_to_workspace(selector, workspace)
	return function()
		local m, window = monitor(selector), hl.get_active_window()
		if m and window then
			hl.dispatch(hl.dsp.focus({ monitor = m }))
			hs.dsp.window.move({ window = window, workspace = workspace, follow = true })()
		end
	end
end

local keypad = { 87, 88, 89, 83, 84, 85, 79, 80, 81, 90 }

for workspace = 1, 10 do
	local digit = "code:" .. tostring(workspace + 9)
	local pad = "code:" .. tostring(keypad[workspace])

	hl.unbind("SUPER + " .. digit)
	hl.unbind("SUPER + SHIFT + " .. digit)

	o.bind("SUPER + " .. digit, "Workspace " .. workspace .. " on LG", focus_workspace(LG, workspace))
	o.bind(
		"SUPER + SHIFT + " .. digit,
		"Move window to workspace " .. workspace .. " on LG",
		move_to_workspace(LG, workspace)
	)

	o.bind("SUPER + " .. pad, "Workspace " .. workspace .. " on Acer", focus_workspace(ACER, workspace))
	o.bind(
		"SUPER + SHIFT + " .. pad,
		"Move window to workspace " .. workspace .. " on Acer",
		move_to_workspace(ACER, workspace)
	)

	o.bind("SUPER + CTRL + " .. digit, "Workspace " .. workspace .. " on laptop", focus_workspace(LAPTOP, workspace))
	o.bind(
		"SUPER + CTRL + SHIFT + " .. digit,
		"Move window to workspace " .. workspace .. " on laptop",
		move_to_workspace(LAPTOP, workspace)
	)
end
