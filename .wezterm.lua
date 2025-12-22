local wezterm = require 'wezterm'

return {
    -- Set PowerShell as default shell
    default_prog = { 'zish' }, -- zellij

    -- Start in fullscreen mode with transparency
    initial_cols = 160,
    initial_rows = 48,
    window_decorations = "NONE",
    window_background_opacity = 0.85, -- Adjust transparency level (0.0 to 1.0)
    window_padding = {
        left = 10,
        right = 10,
        top = 10,
        bottom = 10,
    },
    enable_tab_bar = true,

    

    -- Tab bar settings
    hide_tab_bar_if_only_one_tab = true,
    use_fancy_tab_bar = true,

    -- Keybindings for new tabs and split panes
    keys = {
        {key="t", mods="CTRL|SHIFT", action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
        {key="d", mods="CTRL|SHIFT", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
        {key="v", mods="CTRL|SHIFT", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    },
}
