local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")


local function pad(size)
    local str = ""
    for i = 1, size do
        str = str .. " "
    end
    local pad = wibox.widget.textbox(str)
    return pad
end

local time = wibox.widget.textclock("%H %M")
time.align = "center"
time.valign = "center"
time.font = "sans 50"

local date = wibox.widget.textclock("%a, %B %d")
date.align = "center"
date.valign = "center"
date.font = "sans medium 15"

local temperature_icon = wibox.widget.imagebox(beautiful.temperature_icon)
temperature_icon.resize = true
temperature_icon.forced_width = 40
temperature_icon.forced_height = 40
local temperature_bar = require("noodle.temperature_bar")
local temperature = wibox.widget{
  pad(0),
  {
    temperature_icon,
    pad(1),
    temperature_bar,
    layout = wibox.layout.fixed.horizontal
  },
  pad(0),
  expand = "none",
  layout = wibox.layout.align.horizontal
}

local battery_icon = wibox.widget.imagebox(beautiful.battery_icon)
battery_icon.resize = true
battery_icon.forced_width = 40
battery_icon.forced_height = 40
awesome.connect_signal(
  "charger_plugged", function(c)
    battery_icon.image = beautiful.battery_charging_icon
end)
awesome.connect_signal(
  "charger_unplugged", function(c)
    battery_icon.image = beautiful.battery_icon
end)
local battery_bar = require("noodle.battery_bar")
local battery = wibox.widget{
  pad(0),
  {
    battery_icon,
    pad(1),
    battery_bar,
    layout = wibox.layout.fixed.horizontal
  },
  pad(0),
  expand = "none",
  layout = wibox.layout.align.horizontal
}

local cpu_icon = wibox.widget.imagebox(beautiful.cpu_icon)
cpu_icon.resize = true
cpu_icon.forced_width = 40
cpu_icon.forced_height = 40
local cpu_bar = require("noodle.cpu_bar")
local cpu = wibox.widget{
  pad(0),
  {
    cpu_icon,
    pad(1),
    cpu_bar,
    layout = wibox.layout.fixed.horizontal
  },
  pad(0),
  expand = "none",
  layout = wibox.layout.align.horizontal
}

local ram_icon = wibox.widget.imagebox(beautiful.ram_icon)
ram_icon.resize = true
ram_icon.forced_width = 40
ram_icon.forced_height = 40
local ram_bar = require("noodle.ram_bar")
local ram = wibox.widget({
  pad(0),
  {
    ram_icon,
    pad(1),
    ram_bar,
    layout = wibox.layout.fixed.horizontal
  },
  pad(0),
  expand = "none",
  layout = wibox.layout.align.horizontal
})

local brightness_icon = wibox.widget.imagebox(os.getenv("HOME") .. "/.config/awesome/themes/lovelace/icons/redshift.png")
brightness_icon.resize = true
brightness_icon.forced_width = 40
brightness_icon.forced_height = 40
local brightness_bar = require("brightness_bar")
local brightness = wibox.widget{
  pad(0),
  {
    brightness_icon,
    pad(1),
    brightness_bar,
    layout = wibox.layout.fixed.horizontal
  },
  pad(0),
  expand = "none",
  layout = wibox.layout.align.horizontal
}

local sidebar = awful.wibar({
  position = "left",
  screen = s,
  width = 300,
  visible = false,
  type = "dock",
  ontop = true
})

local volume_icon = wibox.widget.imagebox(beautiful.volume_icon)
volume_icon.resize = true
volume_icon.forced_width = 40
volume_icon.forced_height = 40
local volume_bar = require("noodle.volume_bar")
local volume = wibox.widget{
  pad(0),
  {
    volume_icon,
    pad(1),
    volume_bar,
    layout = wibox.layout.fixed.horizontal
  },
  pad(0),
  expand = "none",
  layout = wibox.layout.align.horizontal
}

-- Create a launcher widget and a main menu
local myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

mymainmenu = awful.menu({ items = {
  { "terminal", terminal, beautiful.terminal_icon },
  { "firefox", os.getenv("HOME") .. "/.opt/firefox-dev/firefox", beautiful.firefox_icon },
  { "files", "nautilus", beautiful.files_icon },
  { "slack", "slack", "/usr/share/pixmaps/slack.png" },
  { "awesome", myawesomemenu, beautiful.awesome_icon }
}})

local mylauncher = awful.widget.launcher({
  image = beautiful.awesome_icon,
  menu = mymainmenu
})
mylauncher.forced_width = 60
mylauncher.forced_height = 60

-- Create an imagebox widget which will contain an icon indicating which layout we're using.
local mylayoutbox = awful.widget.layoutbox(s)
mylayoutbox:buttons(gears.table.join(
                     awful.button({ }, 1, function () awful.layout.inc( 1) end),
                     awful.button({ }, 3, function () awful.layout.inc(-1) end),
                     awful.button({ }, 4, function () awful.layout.inc( 1) end),
                     awful.button({ }, 5, function () awful.layout.inc(-1) end)))
mylayoutbox:set_forced_width(60)
mylayoutbox:set_forced_height(60)

local mypromptbox = awful.widget.prompt()

local sidebar = awful.wibar({
  position = "left",
  screen = s,
  width = 300,
  visible = false,
  type = "dock",
  ontop = true
})

sidebar.bg = beautiful.sidebar_bg or beautiful.wibar_bg or "#111111"
sidebar.fg = beautiful.sidebar_fg or beautiful.wibar_fg or "#FFFFFF"

sidebar.promptbox = mypromptbox

sidebar:setup({
  {
    pad(1),
    pad(1),
    time,
    date,
    pad(1),
    pad(1),
    brightness,
    volume,
    temperature,
    cpu,
    ram,
    battery,
    pad(1),
    layout = wibox.layout.fixed.vertical
  },
  pad(0),
  {
    sidebar.promptbox,
    {
      mylayoutbox,
      pad(5),
      mylauncher,
      layout = wibox.layout.align.horizontal
    },
    layout = wibox.layout.fixed.vertical
  },
  layout = wibox.layout.align.vertical
})

return sidebar
