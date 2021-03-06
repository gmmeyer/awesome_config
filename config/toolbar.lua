local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")

local capi = {
  screen = screen,
  client = client,
}

local widgets = require("actionless.widgets")
local make_separator = require("actionless.widgets.common").make_separator


local toolbar = {}


function toolbar.init(awesome_context)
  local bpc = beautiful.panel_colors
  local loaded_widgets = awesome_context.widgets

  -- Separators
  local sep = wibox.widget.imagebox(beautiful.small_separator)
  local separator  = make_separator(' ')
  local sep_info   = make_separator('sq', {fg=beautiful.color[bpc.info]})
  local sep_media  = make_separator('sq', {fg=beautiful.color[bpc.media]})

  -- Create a wibox for each screen and add it
  local mywibox = {}
  for s = 1, capi.screen.count() do

    -- LEFT side
    local left_layout = wibox.layout.fixed.horizontal()

    left_layout:add(sep)
    left_layout:add(loaded_widgets.screen[s].promptbox)
    left_layout:add(sep)
    left_layout:add(loaded_widgets.screen[s].taglist)
    left_layout:add(separator)

    left_layout:add(loaded_widgets.screen[s].close_button)
    left_layout:add(separator)
    left_layout:add(loaded_widgets.kbd)

    -- RIGHT side
    local right_layout = wibox.layout.fixed.horizontal()

    if bpc.tasklist then
      left_layout:add(make_separator('arrl', {fg=beautiful.color[bpc.tasklist]}))
      right_layout:add(make_separator('arrr', {fg=beautiful.color[bpc.tasklist]}))
    end

    right_layout:add(separator)

    right_layout:add(loaded_widgets.music)
    right_layout:add(separator)
    right_layout:add(loaded_widgets.volume)

    -- sneaky_toggle
    if s == 1 then
      loaded_widgets.systray_toggle = widgets.sneaky_toggle({
          widgets={
            sep_media,
            loaded_widgets.netctl,
            sep_media,
          }, enable_sneaky_tray = true,
      })
      right_layout:add(loaded_widgets.systray_toggle)
    else
      right_layout:add(separator)
    end

    right_layout:add(sep_info)
    right_layout:add(loaded_widgets.mem)
    right_layout:add(loaded_widgets.cpu)
    right_layout:add(loaded_widgets.temp)
    right_layout:add(loaded_widgets.bat)
    right_layout:add(make_separator('arrr', {fg=beautiful.color[bpc.info]}))

    right_layout:add(separator)
    right_layout:add(loaded_widgets.textclock)
    right_layout:add(separator)

    right_layout:add(loaded_widgets.screen[s].layoutbox)
    right_layout:add(sep)


    -- TOOLBAR
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(loaded_widgets.screen[s].tasklist)
    layout:set_right(right_layout)

    -- background image:
    if beautiful.panel_bg_image then
      local layout_bg = wibox.widget.background()
      layout_bg:set_bgimage(beautiful.panel_bg_image)
      layout_bg:set_widget(layout)
      layout = layout_bg
    end

    -- bottom panel padding:
    if beautiful.panel_padding_bottom then
      local const = wibox.layout.constraint()
      const:set_strategy("exact")
      const:set_height(beautiful.panel_padding_bottom)
      local margined_layout = wibox.layout.align.vertical()
      margined_layout:set_middle(layout)
      margined_layout:set_bottom(const)
      layout = margined_layout
    end

    mywibox[s] = awful.wibox({
      position = "top",
      screen = s,
      height = beautiful.panel_height,
    })
    mywibox[s]:set_widget(layout)
    mywibox[s].opacity = beautiful.panel_opacity
    mywibox[s]:set_bg(beautiful.panel_bg)
    mywibox[s]:set_fg(beautiful.panel_fg)

    -- padding for clients' area
    awful.screen.padding(
      capi.screen[s], {
        top = beautiful.screen_padding,
        bottom = beautiful.screen_padding,
        left = beautiful.screen_padding,
        right = beautiful.screen_padding
      }
    )

  end

end
return toolbar
