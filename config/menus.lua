local awful = require("awful")
local awesome = awesome
local menubar = require("actionless.menubar")
local beautiful = require("beautiful")
local capi = { screen = screen }

local get_current_screen = require("actionless.helpers").get_current_screen

local menus = {}


function menus.init(context)

  local applications_menu = {
    { "Graphics", {
      { "Viewnior", "viewnior" },
      { "Nomacs",   "nomacs" },
      { "GIMP",     "gimp" },
    }},
    { "Multimedia", {
      { "Clementine", "clementine" },
      { "mpv", "mpv" },
    }},
    { "Text", {
      { "mEdit", "medit" },
      { "Geany", "geany" },
    }},
    { "terminal", "xterm" }
  }

  -- {{{ Menu
  -- Create a laucher widget and a main menu
  local myawesomemenu = {
    { "manual", context.cmds.terminal .. " -e man awesome" },
    { "edit config", context.cmds.editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", awesome.quit }
  }

  context.menu.mainmenu = awful.menu({items = {
    { "awesome", myawesomemenu, beautiful.awesome_icon },
    { "applications", applications_menu, beautiful.applications_icon },
    { "kill compositor", "killall compton" },
    { "start compositor", context.cmds.compositor },
    { "open terminal", context.cmds.terminal }
  }})
  -- }}}

  -- Menubar configuration
  menubar.utils.terminal = context.cmds.terminal
  menubar.geometry = {
    height = 18,
    width = capi.screen[get_current_screen()].workarea.width,
    x = 0,
    y = capi.screen[get_current_screen()].workarea.height - 18
  }
  menubar.start_scroll_on_item = 10
  -- }}}

end

return menus
