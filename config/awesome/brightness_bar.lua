local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Set colors
local active_color = beautiful.brightness_bar_active_color or "#5AA3CC"
local active_background_color = beautiful.brightness_bar_active_background_color or "#222222"
local update_interval = 10            -- in seconds

local brightness_bar = wibox.widget{
    max_value     = 1,
    value         = 0.5,
    forced_height = 10,
    margins       = {
      top = 10,
      bottom = 10,
    },
    forced_width  = 200,
    shape         = gears.shape.rounded_bar,
    bar_shape     = gears.shape.rounded_bar,
    color         = active_color,
    background_color = active_background_color,
    border_width  = 0,
    border_color  = beautiful.border_color,
    widget        = wibox.widget.progressbar,
}

local function update_widget(stdout)
  brightness_bar.value = tonumber(stdout)
end

local brightness_script = [[
  bash -c '
  bc <<< "scale=2; `cat /sys/class/backlight/intel_backlight/brightness`/`cat /sys/class/backlight/intel_backlight/max_brightness`"
  ']]

function brightness_bar:update()
  update_widget(awful.spawn.with_shell(brightness_script))
end

awful.widget.watch(brightness_script, update_interval, function(widget, stdout) update_widget(stdout) end)

return brightness_bar
