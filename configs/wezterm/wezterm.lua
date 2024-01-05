-- Pull in the wezterm API
local wezterm = require 'wezterm'

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Styling
config.color_scheme = 'OneHalfDark'

local default_font = 'Fira Code'
config.font = wezterm.font(default_font)
config.font_rules = {
  {
    intensity = 'Bold',
    italic = false,
    font = wezterm.font(default_font, { weight = 'Bold', italic = false })
  },
  {
    intensity = 'Bold',
    italic = true,
    font = wezterm.font(default_font, { weight = 'Bold', italic = true })
  },
}
config.font_size = 14.0

-- Disable ligatures
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

config.window_padding = {
  left = '7pt',
  right = '7pt',
  top = '7pt',
  bottom = '7pt',
}

config.set_environment_variables = {
  TERMINFO_DIRS = '/etc/profiles/per-user/ajrae/share/terminfo'
}

-- Tmux like tab bar
config.use_fancy_tab_bar = false
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

-- Disable stuff for TWMing
config.adjust_window_size_when_changing_font_size = false
-- Get rid of top bar, but keep resizing
config.window_decorations = 'RESIZE'

config.dpi_by_screen = {
  ['Pixio PXC348C'] = 72.667,
}

-- SSH Domains
config.ssh_domains = {
  {
    name = 'dev',
    remote_address = 'dev',
    remote_wezterm_path = "/home/ajrae/.nix-profile/bin/wezterm"
  },
}


-- Key binds
local act = wezterm.action
config.keys = {
  -- C-bspc -> C-w
  { key = 'Backspace', mods = 'CTRL', action = act.SendString '\x17' },
  -- Copy and paste
  { key = 'Insert', mods = 'CTRL', action = act.CopyTo 'Clipboard' },
  { key = 'Insert', mods = 'SHIFT', action = act.PasteFrom 'Clipboard' },
  -- For some reason on Mac this unicode is required
  { key = '\u{f746}', mods = 'CTRL', action = act.CopyTo 'Clipboard' },
  { key = '\u{f746}', mods = 'SHIFT', action = act.PasteFrom 'Clipboard' },
  -- Copy Mode
  -- { key = 'Space', mods = 'CTRL | SHIFT', action = act.Multiple {act.ActivateCopyMode, {CopyMode = 'ClearPattern'}} },
  {
    key = 'Space',
    mods = 'CTRL | SHIFT',
    action = wezterm.action_callback(function (window, pane)
        window:perform_action(act.ActivateCopyMode, pane)
        window:perform_action(act.CopyMode 'ClearPattern', pane)
        window:perform_action(act.CopyMode 'ClearSelectionMode', pane)
        window:perform_action(act.CopyMode 'MoveToScrollbackBottom', pane)
    end)
  },
}

local clear_and_close
config.key_tables = {
  copy_mode = {
    { key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
    { key = 'Tab', mods = 'SHIFT', action = act.CopyMode 'MoveBackwardWord' },
    { key = 'Enter', mods = 'NONE', action = act.CopyMode 'MoveToStartOfNextLine' },
    { key = 'Escape', mods = 'NONE', action = act.Multiple {act.ClearSelection, act.CopyMode 'Close' }},
    { key = 'c', mods = 'CTRL', action = act.Multiple {act.ClearSelection, act.CopyMode 'Close' }},
    { key = 'Space', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
    { key = '$', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
    { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
    { key = '/', mods = 'NONE', action = act.Multiple{ {CopyMode = 'ClearPattern'}, {Search = {CaseInSensitiveString = '' } }}},
    { key = '?', mods = 'SHIFT', action = act.Multiple{ {CopyMode = 'ClearPattern'}, {Search = {CaseInSensitiveString = '' } }}},
    { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
    { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
    { key = 'F', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
    { key = 'G', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackBottom' },
    { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
    { key = 'L', mods = 'NONE', action = act.CopyMode 'MoveToViewportBottom' },
    { key = 'M', mods = 'NONE', action = act.CopyMode 'MoveToViewportMiddle' },
    { key = 'N', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
    { key = 'O', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
    { key = 'T', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
    { key = 'V', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Line' } },
    { key = '^', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLineContent' },
    { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
    { key = 'd', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (0.5) } },
    { key = 'e', mods = 'NONE', action = act.CopyMode 'MoveForwardWordEnd' },
    { key = 'f', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = false } } },
    { key = 'g', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop' },
    { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
    { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
    { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
    { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
    { key = 'n', mods = 'NONE', action = act.CopyMode 'NextMatch' },
    { key = 'o', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEnd' },
    { key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
    { key = 't', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = true } } },
    { key = 'u', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (-0.5) } },
    { key = 'v', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
    { key = 'v', mods = 'CTRL', action = act.CopyMode{ SetSelectionMode =  'Block' } },
    { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
    { key = 'y', mods = 'NONE', action = act.Multiple{ { CopyTo =  'ClipboardAndPrimarySelection' }, act.ClearSelection, { CopyMode =  'Close' } } },
    { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
    { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
    { key = 'End', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
    { key = 'Home', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
    { key = 'LeftArrow', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
    { key = 'LeftArrow', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
    { key = 'RightArrow', mods = 'NONE', action = act.CopyMode 'MoveRight' },
    { key = 'RightArrow', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
    { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'MoveUp' },
    { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
  },
  search_mode = {
    {key="Escape", mods="NONE", action=wezterm.action{CopyMode="Close"}},
    -- Go back to copy mode when pressing enter, so that we can use unmodified keys like "n"
    -- to navigate search results without conflicting with typing into the search area.
    {key="Enter", mods="NONE", action="ActivateCopyMode"},
  },
}

return config
