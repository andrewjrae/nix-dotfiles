-- Pull in the wezterm API
local wezterm = require 'wezterm'

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Styling
-- config.color_scheme = 'OneHalfDark'
config.color_scheme = 'OneHalfDark'

config.font = wezterm.font('Fira Code', {weight = 'Regular'})
config.font_size = 14.0
-- Disable ligatures
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

config.window_padding = {
  left = '5pt',
  right = '5pt',
  top = '5pt',
  bottom = '5pt',
}


-- Disable things I don't need
config.enable_tab_bar = false
config.adjust_window_size_when_changing_font_size = false
-- Get rid of top bar, but keep resizing
config.window_decorations = 'RESIZE'

return config
