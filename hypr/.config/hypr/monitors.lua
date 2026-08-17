hl.monitor({ output = "eDP-2", mode = "2560x1600@240", position = "4800x0", scale = "auto" })
--hl.monitor({ output = "eDP-2", mode = "2560x1600@60", position = "4800x0", scale = "auto" })

-- LG UltraFine
hl.monitor({
	output = "desc:LG Electronics LG ULTRAFINE 308NTYT8W962",
	mode = "3840x2160@60",
	position = "0x0",
	scale = 1.6,
})

-- Acer X32 V2
hl.monitor({
	output = "desc:Acer Technologies X32 V2 15380001D3900",
	mode = "3840x2160@165",
	position = "2400x0",
	scale = 1.6,
})

hl.config({
	misc = {
		vrr = 1,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		disable_autoreload = true,
	},

	binds = {
		allow_workspace_cycles = false,
	},
})
