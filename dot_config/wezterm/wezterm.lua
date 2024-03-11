local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'Kanagawa (Gogh)'
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font 'FiraMono Nerd Font Mono'
config.window_padding = {
  left = 2,
  right = 2,
  top = 0,
  bottom = 0,
}

return config
