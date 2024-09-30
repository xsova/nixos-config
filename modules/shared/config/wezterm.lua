local wezterm = require 'wezterm';

function scheme_for_appearance(appearance)
  local helix_config = "~/.config/fish/config.toml"

  if appearance:find "Dark" then
    io.popen("sed -i '' 's/theme = \"catppuccin_latte\"/theme = \"catppuccin_mocha\"/g' ~/.config/helix/config.toml"):close()
    io.popen("fish_config theme choose Catppuccin\\ Mocha"):close()
    return "Catppuccin Mocha"
  else
    io.popen("sed -i '' 's/theme = \"catppuccin_mocha\"/theme = \"catppuccin_latte\"/g' ~/.config/helix/config.toml"):close()
    io.popen("fish_config theme choose Catppuccin\\ Latte"):close()
    return "Catppuccin Latte"
  end
end

return {
  -- font = wezterm.font('TerminalVector'),
  font = wezterm.font('MD IO Trial'),
  font_size = 12,
  window_padding = {
    left = 15,
    right = 15,
    top = 15,
    bottom = 15,
  },
  window_background_opacity = 0.8,
  text_background_opacity = 0.7,
  window_decorations = "RESIZE",
  enable_tab_bar = false,
  color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
  macos_window_background_blur = 19,
  keys = {
    {
      key = 'w',
      mods = 'CMD',
      action = wezterm.action.CloseCurrentTab { confirm = true },
    },
  },
}
