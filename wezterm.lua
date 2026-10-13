local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- ====================================================================
-- 1. Appearance & Theme (Auto Dark / Light Mode)
-- ====================================================================
local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

local function scheme_for_appearance(appearance)
  if appearance:find('Dark') then
    return 'Tokyo Night'
  else
    return 'Tokyo Night Day'
  end
end

config.color_scheme = scheme_for_appearance(get_appearance())

-- Typography: JetBrains Mono with coding ligatures & slashed zeros
config.font = wezterm.font_with_fallback({
  'JetBrains Mono',
  'Symbols Nerd Font Mono',
  'Menlo',
})
config.font_size = 14.0
config.line_height = 1.15
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1', 'zero=1' }

-- Smooth rendering for Apple Silicon ProMotion (120Hz)
config.max_fps = 120
config.animation_fps = 60

-- macOS Window styling: Integrated traffic lights, subtle blur, and sleek padding
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.window_background_opacity = 0.95
config.macos_window_background_blur = 30
config.window_padding = {
  left = 14,
  right = 14,
  top = 12,
  bottom = 10,
}

-- Keep window dimensions stable when zooming fonts
config.adjust_window_size_when_changing_font_size = false

-- Subtly dim inactive split panes for visual focus
config.inactive_pane_hsb = {
  saturation = 0.85,
  brightness = 0.75,
}

-- Cursor styling: Clean blinking vertical bar
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 600

-- Sound & Bell: Silent visual bell
config.audible_bell = 'Disabled'
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 150,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 150,
}

-- Tab Bar & Scrollback
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 25
config.enable_scroll_bar = false
config.scrollback_lines = 10000

-- Tab Bar Colors matching Tokyo Night
config.colors = {
  tab_bar = {
    background = '#16161e',
    active_tab = {
      bg_color = '#1f2335',
      fg_color = '#c0caf5',
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = '#16161e',
      fg_color = '#565f89',
    },
    inactive_tab_hover = {
      bg_color = '#24283b',
      fg_color = '#c0caf5',
    },
    new_tab = {
      bg_color = '#16161e',
      fg_color = '#7aa2f7',
    },
    new_tab_hover = {
      bg_color = '#24283b',
      fg_color = '#7aa2f7',
    },
  },
}

-- ====================================================================
-- 2. macOS Keyboard & Alt Key Behavior
-- ====================================================================
-- Left Option acts as Alt/Meta (word jumping with Option+Left/Right or Option+b/f)
-- Right Option remains available for special character typing
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

-- ====================================================================
-- 3. Mouse & Selection (Hold SHIFT to bypass CLI/TUI mouse capture)
-- ====================================================================
config.bypass_mouse_reporting_modifiers = 'SHIFT'

config.mouse_bindings = {
  -- Smart Right-Click: Copy if selection exists, Paste if not
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ''
      if has_selection then
        window:perform_action(act.CopyTo 'ClipboardAndPrimarySelection', pane)
        window:perform_action(act.ClearSelection, pane)
      else
        window:perform_action(act.PasteFrom 'Clipboard', pane)
      end
    end),
  },

  -- Middle-Click: Paste from clipboard
  {
    event = { Down = { streak = 1, button = 'Middle' } },
    mods = 'NONE',
    action = act.PasteFrom 'Clipboard',
  },

  -- Releasing Left Mouse button auto-copies to clipboard ONLY when text was selected
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelection 'ClipboardAndPrimarySelection',
  },
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'SHIFT',
    action = act.CompleteSelection 'ClipboardAndPrimarySelection',
  },
}

-- ====================================================================
-- 4. Developer Hyperlinks & VS Code Direct Opener
-- ====================================================================
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Match file paths with line & column numbers and route to VS Code
table.insert(config.hyperlink_rules, {
  regex = [[([\w\.\-/]+\.[a-zA-Z0-9_]+):(\d+)(?::(\d+))?]],
  format = 'vscode://file$PWD/$1:$2:$3',
})

-- Intercept and open directly in VS Code
wezterm.on('open-uri', function(window, pane, uri)
  local start = uri:find('vscode://file$PWD', 1, true)
  if start then
    local cwd_uri = pane:get_current_working_dir()
    if cwd_uri and cwd_uri.file_path then
      local final_uri = uri:gsub('$PWD', cwd_uri.file_path)
      wezterm.open_with(final_uri)
      return false
    end
  end
end)

-- Developer QuickSelect Patterns (Git hashes, IPs, UUIDs, stack traces)
config.quick_select_patterns = {
  [[(?:[\w\.\-/]+):(?:\d+)(?::(?:\d+))?]],
  [[(?:[0-9a-f]{7,40})]],
  [[(?:[0-9]{1,3}\.){3}[0-9]{1,3}(?::[0-9]{1,5})?]],
  [[(?:[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})]],
}

-- ====================================================================
-- 5. Developer Launch Menu & Dynamic Hints
-- ====================================================================
config.launch_menu = {
  { label = 'Yazi (Terminal File Manager)', args = { '/opt/homebrew/bin/yazi' } },
  { label = 'Neovim (Code Editor)', args = { '/opt/homebrew/bin/nvim' } },
  { label = 'Lazygit (Git UI)', args = { '/opt/homebrew/bin/lazygit' } },
  { label = 'Lazydocker (Docker UI)', args = { '/opt/homebrew/bin/lazydocker' } },
  { label = 'Lazysql (Database UI)', args = { '/opt/homebrew/bin/lazysql' } },
  { label = 'Dust (Disk Space Analyzer)', args = { '/opt/homebrew/bin/dust' } },
  { label = 'Btop (System Monitor)', args = { '/opt/homebrew/bin/btop' } },
  { label = 'Node REPL', args = { '/opt/homebrew/bin/node' } },
  { label = 'Python 3 REPL', args = { '/usr/local/bin/python3' } },
  { label = 'Top Process Monitor', args = { 'top' } },
}

-- Rotating Hints & Command Suggestions (cycles periodically in the status bar)
local hints = {
  { key = '⌘D', desc = 'Split right' },
  { key = '⌘⇧D', desc = 'Split down' },
  { key = '⌘⇧I', desc = 'Scratchpad drawer' },
  { key = '⌘⇧Z', desc = 'Zoom active pane' },
  { key = '⌘⇧R', desc = 'Resize mode' },
  { key = '⌘⇧Y', desc = 'Yazi files' },
  { key = '⌘⇧V', desc = 'Neovim editor' },
  { key = '⌘⇧G', desc = 'Lazygit' },
  { key = '⌘⇧K', desc = 'Lazydocker' },
  { key = '⌘⇧U', desc = 'Lazysql' },
  { key = '⌘⇧B', desc = 'Btop monitor' },
  { key = '⌘⇧O', desc = 'Git repos' },
  { key = '⌘⇧T', desc = 'Tab search' },
  { key = '⌘⇧E', desc = 'Open link' },
  { key = '⌘⌥H/J/K/L', desc = 'Vim pane jump' },
  { key = '⇧PgUp/Dn', desc = 'Page scroll' },
  { key = '⌘1..9', desc = 'Direct tab' },
  { key = 'Drag mouse', desc = 'Auto-copy text' },
  { key = 'Right-click', desc = 'Smart copy/paste' },
  { key = '⌘⇧Space', desc = 'QuickSelect' },
  { key = '⌘⇧X', desc = 'Copy mode' },
  { key = '⌘⇧S', desc = 'Workspaces' },
  { key = '⌘⇧N', desc = 'New workspace' },
  { key = '⌘⇧↑/↓', desc = 'Jump prompt' },
  { key = '⇧+Drag', desc = 'Select text' },
  { key = '⌘+Click', desc = 'Open in VS Code' },
  { key = '⌥+Arrows', desc = 'Word jump' },
  { key = '⌘K', desc = 'Clear screen' },
  { key = '⌘⇧P', desc = 'Command palette' },
  { key = '⌘⇧L', desc = 'Launch menu' },
  { key = '⌘⇧H', desc = 'Hints guide' },
}

local hint_choices = {}
for _, h in ipairs(hints) do
  table.insert(hint_choices, {
    id = h.key,
    label = string.format('%-12s →  %s', h.key, h.desc),
  })
end

-- ====================================================================
-- 6. Keybindings (Multiplexing, Workspaces, Resizing & Navigation)
-- ====================================================================
config.keys = {
  -- Clipboard & Copy/Paste
  { key = 'c', mods = 'CMD', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CMD', action = act.PasteFrom 'Clipboard' },
  { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },

  -- Smart Ctrl+C: Interrupt if idle, Copy if text selected
  {
    key = 'c',
    mods = 'CTRL',
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ''
      if has_selection then
        window:perform_action(act.CopyTo 'Clipboard', pane)
        window:perform_action(act.ClearSelection, pane)
      else
        window:perform_action(act.SendKey { key = 'c', mods = 'CTRL' }, pane)
      end
    end),
  },

  -- Tabs Management
  { key = 't', mods = 'CMD', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CMD', action = act.CloseCurrentPane { confirm = false } },
  { key = '[', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = ']', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(1) },
  { key = 't', mods = 'CMD|SHIFT', action = act.ShowLauncherArgs { flags = 'FUZZY|TABS' } },

  -- Splits / Panes (Horizontal & Vertical)
  { key = 'd', mods = 'CMD', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'CMD|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'z', mods = 'CMD|SHIFT', action = act.TogglePaneZoomState },
  { key = '[', mods = 'CMD', action = act.ActivatePaneDirection 'Prev' },
  { key = ']', mods = 'CMD', action = act.ActivatePaneDirection 'Next' },
  -- Arrow & Vim (H/J/K/L) Pane Navigation
  { key = 'LeftArrow', mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow', mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow', mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Down' },
  { key = 'h', mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Down' },

  -- Interactive Pane Resize Mode (Cmd+Shift+R)
  { key = 'r', mods = 'CMD|SHIFT', action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false } },

  -- Keyboard Scrollback (Page Up/Down without trackpad)
  { key = 'PageUp', mods = 'SHIFT', action = act.ScrollByPage(-0.5) },
  { key = 'PageDown', mods = 'SHIFT', action = act.ScrollByPage(0.5) },
  { key = 'PageUp', mods = 'CMD', action = act.ScrollToTop },
  { key = 'PageDown', mods = 'CMD', action = act.ScrollToBottom },

  -- Semantic Prompt Scrolling (Jump between command prompts in terminal history)
  { key = 'UpArrow', mods = 'CMD|SHIFT', action = act.ScrollToPrompt(-1) },
  { key = 'DownArrow', mods = 'CMD|SHIFT', action = act.ScrollToPrompt(1) },

  -- Keyboard URL Opener (Opens links in browser with letter hints - zero mouse)
  {
    key = 'e',
    mods = 'CMD|SHIFT',
    action = act.QuickSelectArgs {
      patterns = { 'https?://[^\\s]+' },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        if url and url ~= '' then
          wezterm.open_with(url)
        end
      end),
    },
  },

  -- Workspaces & Sessions
  { key = 's', mods = 'CMD|SHIFT', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
  {
    key = 'n',
    mods = 'CMD|SHIFT',
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { Color = '#7aa2f7' } },
        { Text = 'Create & Switch to Workspace:' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        if line and line ~= '' then
          window:perform_action(act.SwitchToWorkspace { name = line }, pane)
        end
      end),
    },
  },

  -- Launch Menu, Tools & Command Palette
  { key = 'l', mods = 'CMD|SHIFT', action = act.ShowLauncherArgs { flags = 'FUZZY|LAUNCH_MENU_ITEMS|DOMAINS' } },
  { key = 'p', mods = 'CMD|SHIFT', action = act.ActivateCommandPalette },
  { key = 'y', mods = 'CMD|SHIFT', action = act.SpawnCommandInNewTab { args = { '/opt/homebrew/bin/yazi' } } },
  { key = 'v', mods = 'CMD|SHIFT', action = act.SpawnCommandInNewTab { args = { '/opt/homebrew/bin/nvim' } } },
  { key = 'g', mods = 'CMD|SHIFT', action = act.SpawnCommandInNewTab { args = { '/opt/homebrew/bin/lazygit' } } },
  { key = 'b', mods = 'CMD|SHIFT', action = act.SpawnCommandInNewTab { args = { '/opt/homebrew/bin/btop' } } },
  { key = 'k', mods = 'CMD|SHIFT', action = act.SpawnCommandInNewTab { args = { '/opt/homebrew/bin/lazydocker' } } },
  { key = 'u', mods = 'CMD|SHIFT', action = act.SpawnCommandInNewTab { args = { '/opt/homebrew/bin/lazysql' } } },
  { key = 'i', mods = 'CMD|SHIFT', action = act.SplitPane { direction = 'Down', size = { Percent = 35 } } },
  {
    key = 'o',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local home = os.getenv('HOME') or '/Users/tr'
      local success, stdout, stderr = wezterm.run_child_process({
        '/opt/homebrew/bin/fd',
        '-H',
        '-td',
        '^\\.git$',
        home,
        '--max-depth',
        '4',
        '--prune',
      })
      local choices = {}
      if success and stdout then
        for line in stdout:gmatch('[^\r\n]+') do
          local project_dir = line:gsub('/.git/?$', '')
          local name = project_dir:match('([^/]+)$') or project_dir
          local display = project_dir
          if display:sub(1, #home) == home then
            display = '~' .. display:sub(#home + 1)
          end
          table.insert(choices, {
            id = project_dir,
            label = string.format('📁 %-20s (%s)', name, display),
          })
        end
      end
      if #choices > 0 then
        window:perform_action(
          act.InputSelector {
            title = '🚀 Open Project in Workspace',
            choices = choices,
            fuzzy = true,
            action = wezterm.action_callback(function(w, p, id, label)
              if id then
                local name = id:match('([^/]+)$') or 'project'
                w:perform_action(act.SwitchToWorkspace {
                  name = name,
                  spawn = { cwd = id },
                }, p)
              end
            end),
          },
          pane
        )
      else
        window:toast_notification('Project Switcher', 'No git repositories found in max depth 4', nil, 3000)
      end
    end),
  },
  {
    key = 'h',
    mods = 'CMD|SHIFT',
    action = act.InputSelector {
      title = '💡 WezTerm Command Hints (type to search)',
      choices = hint_choices,
      fuzzy = true,
      action = wezterm.action_callback(function(window, pane, id, label)
        if id then
          window:toast_notification('WezTerm Hint', label, nil, 5000)
        end
      end),
    },
  },

  -- Search, Copy Mode & QuickSelect
  { key = 'f', mods = 'CMD', action = act.Search 'CurrentSelectionOrEmptyString' },
  { key = 'x', mods = 'CMD|SHIFT', action = act.ActivateCopyMode },
  { key = 'x', mods = 'CTRL|SHIFT', action = act.ActivateCopyMode },
  { key = 'Space', mods = 'CMD|SHIFT', action = act.QuickSelect },

  -- Terminal Utilities
  { key = 'k', mods = 'CMD', action = act.ClearScrollback 'ScrollbackAndViewport' },

  -- Font Size Zoom
  { key = '=', mods = 'CMD', action = act.IncreaseFontSize },
  { key = '+', mods = 'CMD', action = act.IncreaseFontSize },
  { key = '-', mods = 'CMD', action = act.DecreaseFontSize },
  { key = '0', mods = 'CMD', action = act.ResetFontSize },
}

-- Jump directly to Tabs 1 - 9 with Cmd+1 .. Cmd+9
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'CMD',
    action = act.ActivateTab(i - 1),
  })
end

-- Key Tables: Fluid Pane Resizing
config.key_tables = {
  resize_pane = {
    { key = 'LeftArrow', action = act.AdjustPaneSize { 'Left', 3 } },
    { key = 'h', action = act.AdjustPaneSize { 'Left', 3 } },
    { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 3 } },
    { key = 'l', action = act.AdjustPaneSize { 'Right', 3 } },
    { key = 'UpArrow', action = act.AdjustPaneSize { 'Up', 3 } },
    { key = 'k', action = act.AdjustPaneSize { 'Up', 3 } },
    { key = 'DownArrow', action = act.AdjustPaneSize { 'Down', 3 } },
    { key = 'j', action = act.AdjustPaneSize { 'Down', 3 } },
    { key = 'Escape', action = 'PopKeyTable' },
    { key = 'Enter', action = 'PopKeyTable' },
  },
}

-- ====================================================================
-- 7. Clean Tab Titles & Dynamic Status Bar (Hints, Battery & Time)
-- ====================================================================
local function clean_tab_title(tab)
  local pane = tab.active_pane
  local title = pane.title or ''

  if title == '' and pane.foreground_process_name then
    title = pane.foreground_process_name:match('([^/\\]+)$') or 'shell'
  end

  -- If title is a path (e.g. ~/Documents/UEM), extract only the folder basename
  if title:find('/') or title:find('\\') then
    title = title:gsub('[/\\]+$', '')
    local basename = title:match('([^/\\]+)$')
    if basename and basename ~= '' then
      title = basename
    end
  end

  -- Clean up home directory or empty title
  if title == '' or title == os.getenv('USER') then
    title = '~'
  end

  -- Truncate to maximum 14 characters with ellipsis so tabs never crowd the tab bar
  if #title > 14 then
    title = title:sub(1, 13) .. '…'
  end

  return title
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config_arg, hover, max_width)
  local title = clean_tab_title(tab)
  local index = tab.tab_index + 1

  local bg = '#16161e'
  local fg = '#565f89'
  local intensity = 'Normal'

  if tab.is_active then
    bg = '#24283b'
    fg = '#7aa2f7'
    intensity = 'Bold'
  elseif hover then
    bg = '#1f2335'
    fg = '#c0caf5'
  end

  return {
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Attribute = { Intensity = intensity } },
    { Text = string.format(' %d: %s ', index, title) },
  }
end)

wezterm.on('update-right-status', function(window, pane)
  local cells = {}

  -- 1. Modal key table indicator (e.g. RESIZE_PANE)
  local mode = window:active_key_table()
  if mode then
    table.insert(cells, { Background = { Color = '#e0af68' } })
    table.insert(cells, { Foreground = { Color = '#1a1b26' } })
    table.insert(cells, { Attribute = { Intensity = 'Bold' } })
    table.insert(cells, { Text = ' ' .. string.upper(mode) .. ' ' })
  end

  -- 2. Rotating Command Hint (concise, updates every 12s)
  local now = os.time()
  local hint_idx = (math.floor(now / 12) % #hints) + 1
  local hint = hints[hint_idx]
  table.insert(cells, { Foreground = { Color = '#e0af68' } })
  table.insert(cells, { Text = ' 💡 ' .. hint.key .. ': ' .. hint.desc .. ' ' })

  -- 3. Workspace badge (shown only when inside a named workspace)
  local workspace = window:active_workspace()
  if workspace and workspace ~= 'default' then
    table.insert(cells, { Foreground = { Color = '#bb9af7' } })
    table.insert(cells, { Text = '  ' .. workspace .. ' ' })
  end

  -- 4. Battery Indicator (for MacBooks)
  for _, b in ipairs(wezterm.battery_info()) do
    local charge = b.state_of_charge * 100
    local icon = '󰁹'
    if charge <= 20 then
      icon = '󰂃'
    elseif charge <= 40 then
      icon = '󰁼'
    elseif charge <= 60 then
      icon = '󰁾'
    elseif charge <= 80 then
      icon = '󰂀'
    end
    table.insert(cells, { Foreground = { Color = charge <= 20 and '#f7768e' or '#9ece6a' } })
    table.insert(cells, { Text = ' ' .. icon .. string.format(' %.0f%% ', charge) })
  end

  -- 5. Current Time
  local time = wezterm.strftime('%I:%M %p')
  table.insert(cells, { Foreground = { Color = '#7aa2f7' } })
  table.insert(cells, { Text = ' ' .. time .. ' ' })

  window:set_right_status(wezterm.format(cells))
end)

return config
