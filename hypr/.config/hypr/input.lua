hl.config({
  input = {
    -- us + Canadian French, switch with Left Alt + Right Alt.
    kb_layout = "us,ca",
    kb_variant = ",fr",
    kb_options = "compose:caps,grp:alts_toggle",

    repeat_rate = 40,
    repeat_delay = 600,

    numlock_by_default = true,

    touchpad = {
      scroll_factor = 0.4,
    },
  },
})

o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })
