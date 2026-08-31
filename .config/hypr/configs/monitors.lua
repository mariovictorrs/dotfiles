------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "auto",
})

hl.monitor({
  output = "eDP-1",
  mode = "preferred",
  position = "auto",
  scale = "1.25",
})

-- unscale Xwayland
hl.config({
  xwayland = {
    force_zero_scaling = true,
  },
})
