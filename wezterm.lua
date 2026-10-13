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
config.tab_max_width = 28
config.enable_scroll_bar = false
config.scrollback_lines = 10000
config.status_update_interval = 250

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
-- 4. Developer Hyperlinks & Terminal Neovim Direct Opener (Zero GUI)
-- ====================================================================
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Match file paths with line & column numbers and route to terminal Neovim
table.insert(config.hyperlink_rules, {
  regex = [[([\w\.\-/]+\.[a-zA-Z0-9_]+):(\d+)(?::(\d+))?]],
  format = 'nvim://file$PWD/$1:$2',
})

-- Intercept and open directly in Neovim within WezTerm (100% keyboard & terminal base)
wezterm.on('open-uri', function(window, pane, uri)
  local nvim_start = uri:find('nvim://file', 1, true)
  if nvim_start then
    local cwd_uri = pane:get_current_working_dir()
    local base_cwd = (cwd_uri and cwd_uri.file_path) or os.getenv('HOME') or '/Users/tr'
    local path_part = uri:gsub('^nvim://file$PWD/', ''):gsub('^nvim://file/', '')
    local file, line = path_part:match('([^:]+):?(%d*)')
    if file then
      local full_path = file:match('^/') and file or (base_cwd .. '/' .. file)
      local args = { '/opt/homebrew/bin/nvim' }
      if line and line ~= '' then
        table.insert(args, '+' .. line)
      end
      table.insert(args, full_path)
      window:perform_action(
        act.SpawnCommandInNewTab {
          args = args,
          cwd = base_cwd,
        },
        pane
      )
      return false
    end
  end
end)

-- Developer QuickSelect Patterns (URLs, Git hashes, IPs, UUIDs, stack traces, env vars)
config.quick_select_patterns = {
  [[(?:https?://[^\s'"`\(\)\[\]{}]+)]],
  [[(?:[\w\.\-/]+\.[a-zA-Z0-9_]+:\d+(?::\d+)?)]],
  [[(?:[0-9a-f]{7,40})]],
  [[(?:[0-9]{1,3}\.){3}[0-9]{1,3}(?::[0-9]{1,5})?]],
  [[(?:[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})]],
  [[(?:#[0-9a-fA-F]{6})]],
  [[(?:v?[0-9]+\.[0-9]+\.[0-9]+)]],
  [[(?:[A-Za-z_][A-Za-z0-9_]*=[^\s]+)]],
}

-- ====================================================================
-- 5. Developer Launch Menu & Dynamic Hints
-- ====================================================================
config.launch_menu = {
  { label = '⚡ Terminal Dashboard (Home Base)', args = { '/Users/tr/dotfiles/bin/term-dash' } },
  { label = 'Antigravity CLI (Agent)', args = { '/Users/tr/.local/bin/agy' } },
  { label = 'Yazi (Terminal File Manager)', args = { '/opt/homebrew/bin/yazi' } },
  { label = 'Neovim (Code Editor)', args = { '/opt/homebrew/bin/nvim' } },
  { label = 'W3M (CLI Web Browser)', args = { '/opt/homebrew/bin/w3m', 'https://duckduckgo.com' } },
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
  { key = '⌘⌥D', desc = 'Terminal Base Dashboard' },
  { key = 'dash', desc = 'Interactive dev dashboard' },
  { key = '⌘D', desc = 'Split right' },
  { key = '⌘⇧D', desc = 'Split down' },
  { key = '⌘⇧I', desc = 'Scratchpad drawer' },
  { key = '⌘⇧Z', desc = 'Zoom active pane' },
  { key = '⌘⇧R', desc = 'Resize mode' },
  { key = '⌘⇧Y', desc = 'Yazi files' },
  { key = '⌘⇧V', desc = 'Neovim editor' },
  { key = 'pic <file>', desc = 'View image & copy' },
  { key = 'vid <file>', desc = 'Play video & copy' },
  { key = 'browse <url>', desc = 'Terminal browser' },
  { key = '⌘⇧A', desc = 'Antigravity agent' },
  { key = '⌘⌥A', desc = 'AGY split right' },
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
  { key = '⌘+Click', desc = 'Open in Neovim' },
  { key = '⌥+Arrows', desc = 'Word jump' },
  { key = '⌘⇧W', desc = 'Visual pane jump' },
  { key = '⌘⌥W', desc = 'Visual pane swap' },
  { key = '⌘⌥O', desc = 'Rotate split panes' },
  { key = '⌘⇧{ / }', desc = 'Move tab left / right' },
  -- AeroSpace tiling WM shortcuts
  { key = '⌥H/J/K/L', desc = 'AeroSpace: focus window' },
  { key = '⌥⇧H/J/K/L', desc = 'AeroSpace: move window' },
  { key = '⌥1-9', desc = 'AeroSpace: switch workspace' },
  { key = '⌥⇧1-9', desc = 'AeroSpace: move to workspace' },
  { key = '⌥F', desc = 'AeroSpace: fullscreen toggle' },
  { key = '⌥Space', desc = 'AeroSpace: float toggle' },
  { key = '⌥R', desc = 'AeroSpace: resize mode' },
  -- Shell superpowers
  { key = 'furl', desc = 'Fuzzy URL picker' },
  { key = 'reader', desc = 'Terminal web reader' },
  { key = 'fkill', desc = 'Process assassin' },
  { key = 'scratch', desc = 'Scratchpad note' },
  { key = 'frebase', desc = 'Interactive git rebase' },
  { key = 'fix', desc = 'AI error fixer' },
  { key = 'ai', desc = 'Ask Antigravity AI' },
  { key = 'task', desc = 'Run project tasks' },
  { key = 'sandbox', desc = 'Ephemeral code playground' },
  { key = 'clipimg', desc = 'Save clipboard screenshot' },
  { key = 'envswitch', desc = 'Switch .env variant' },
  { key = 'greview', desc = 'Side-by-side branch review' },
  { key = 'cl', desc = 'Copy last cmd output' },
  { key = 'fmod', desc = 'Fuzzy git changed files' },
  { key = 'fgb', desc = 'Fuzzy git branches' },
  { key = 'Ctrl+F', desc = 'Project sessionizer' },
  { key = 'pm', desc = 'Polyglot package runner' },
  { key = 'gpush-ai', desc = 'AI commit & push' },
  { key = 'gcp', desc = 'Stage all, commit & push' },
  { key = 'watchrun', desc = 'Auto test runner on save' },
  { key = 'loop', desc = 'Alias for watchrun' },
  { key = 'envsafe', desc = 'Safe .env preview' },
  { key = 'dotsync', desc = 'Sync dotfiles to GitHub' },
  { key = 'dot', desc = 'Fuzzy dotfiles editor' },
  { key = 'fapp', desc = 'Zero-touchpad app switcher' },
  { key = '⌥Space', desc = 'Quake dropdown WezTerm' },
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

-- Helper to detect if the foreground process running in the pane is Neovim / Vim
local function is_vim_process(pane)
  local process_name = pane:get_foreground_process_name()
  if not process_name then
    return false
  end
  local name = process_name:match('([^/\\]+)$') or ''
  return name == 'nvim' or name == 'vim' or name == 'vi'
end

-- Smart navigation: Seamlessly traversable across WezTerm panes and Neovim window splits
local function smart_navigate(window, pane, key, direction)
  if is_vim_process(pane) then
    -- Forward Ctrl+key to Neovim so Neovim moves its own split first.
    -- When Neovim hits the window split border, its s:SmartSplitSwitch invokes
    -- 'wezterm cli activate-pane-direction' to jump into the adjacent WezTerm pane.
    window:perform_action(act.SendKey { key = key, mods = 'CTRL' }, pane)
  else
    window:perform_action(act.ActivatePaneDirection(direction), pane)
  end
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
  { key = '{', mods = 'CMD|SHIFT', action = act.MoveTabRelative(-1) },
  { key = '}', mods = 'CMD|SHIFT', action = act.MoveTabRelative(1) },
  { key = 't', mods = 'CMD|SHIFT', action = act.ShowLauncherArgs { flags = 'FUZZY|TABS' } },

  -- Splits / Panes (Horizontal & Vertical)
  { key = 'd', mods = 'CMD', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'CMD|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'z', mods = 'CMD|SHIFT', action = act.TogglePaneZoomState },
  { key = '[', mods = 'CMD', action = act.ActivatePaneDirection 'Prev' },
  { key = ']', mods = 'CMD', action = act.ActivatePaneDirection 'Next' },
  -- Zero-Touchpad Visual Pane Jump (Cmd+Shift+W) & Visual Pane Swap (Cmd+Alt+W)
  { key = 'w', mods = 'CMD|SHIFT', action = act.PaneSelect { alphabet = '1234567890abcdefghijklmnopqrstuvwxyz' } },
  { key = 'w', mods = 'CMD|ALT', action = act.PaneSelect { mode = 'SwapWithActive', alphabet = '1234567890abcdefghijklmnopqrstuvwxyz' } },
  { key = 'o', mods = 'CMD|ALT', action = act.RotatePanes 'Clockwise' },
  -- Seamless Arrow & Vim (H/J/K/L) Navigation Across WezTerm Panes and Neovim Splits
  { key = 'LeftArrow', mods = 'CMD|ALT', action = wezterm.action_callback(function(win, pane) smart_navigate(win, pane, 'h', 'Left') end) },
  { key = 'RightArrow', mods = 'CMD|ALT', action = wezterm.action_callback(function(win, pane) smart_navigate(win, pane, 'l', 'Right') end) },
  { key = 'UpArrow', mods = 'CMD|ALT', action = wezterm.action_callback(function(win, pane) smart_navigate(win, pane, 'k', 'Up') end) },
  { key = 'DownArrow', mods = 'CMD|ALT', action = wezterm.action_callback(function(win, pane) smart_navigate(win, pane, 'j', 'Down') end) },
  { key = 'h', mods = 'CMD|ALT', action = wezterm.action_callback(function(win, pane) smart_navigate(win, pane, 'h', 'Left') end) },
  { key = 'l', mods = 'CMD|ALT', action = wezterm.action_callback(function(win, pane) smart_navigate(win, pane, 'l', 'Right') end) },
  { key = 'k', mods = 'CMD|ALT', action = wezterm.action_callback(function(win, pane) smart_navigate(win, pane, 'k', 'Up') end) },
  { key = 'j', mods = 'CMD|ALT', action = wezterm.action_callback(function(win, pane) smart_navigate(win, pane, 'j', 'Down') end) },

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
  { key = 'a', mods = 'CMD|SHIFT', action = act.SpawnCommandInNewTab { args = { '/Users/tr/.local/bin/agy' } } },
  { key = 'a', mods = 'CMD|ALT', action = act.SplitPane { direction = 'Right', size = { Percent = 40 }, command = { args = { '/Users/tr/.local/bin/agy' } } } },
  { key = 'd', mods = 'CMD|ALT', action = act.SpawnCommandInNewTab { args = { '/Users/tr/dotfiles/bin/term-dash' } } },
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
  copy_mode = {
    { key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
    { key = 'Tab', mods = 'SHIFT', action = act.CopyMode 'MoveBackwardWord' },
    { key = 'Enter', mods = 'NONE', action = act.CopyMode 'MoveToStartOfNextLine' },
    { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
    { key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
    { key = 'c', mods = 'CTRL', action = act.CopyMode 'Close' },

    -- Cursor motions (Vim standard)
    { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
    { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
    { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
    { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
    { key = 'LeftArrow', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
    { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
    { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'MoveUp' },
    { key = 'RightArrow', mods = 'NONE', action = act.CopyMode 'MoveRight' },

    -- Word & line motions
    { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
    { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
    { key = 'e', mods = 'NONE', action = act.CopyMode 'MoveForwardWordEnd' },
    { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
    { key = '^', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLineContent' },
    { key = '$', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },

    -- Visual selection (Character, Line, Block)
    { key = 'v', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Cell' } },
    { key = 'V', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Line' } },
    { key = 'v', mods = 'CTRL', action = act.CopyMode { SetSelectionMode = 'Block' } },

    -- Yank directly to macOS system clipboard & close
    { key = 'y', mods = 'NONE', action = act.Multiple { { CopyTo = 'ClipboardAndPrimarySelection' }, { CopyMode = 'Close' } } },

    -- Viewport scrolling
    { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
    { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
    { key = 'u', mods = 'CTRL', action = act.CopyMode { MoveByPage = -0.5 } },
    { key = 'd', mods = 'CTRL', action = act.CopyMode { MoveByPage = 0.5 } },
    { key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
    { key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
    { key = 'g', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop' },
    { key = 'G', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackBottom' },
    { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
    { key = 'M', mods = 'NONE', action = act.CopyMode 'MoveToViewportMiddle' },
    { key = 'L', mods = 'NONE', action = act.CopyMode 'MoveToViewportBottom' },

    -- Search
    { key = '/', mods = 'NONE', action = act.Search { CaseSensitiveString = '' } },
  },
}

-- ====================================================================
-- 7. Task Activity, Loading Spinners & Completion Highlighting
-- ====================================================================
local SPINNER = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
local spinner_idx = 1

local shells = {
  zsh = true,
  bash = true,
  sh = true,
  fish = true,
  csh = true,
  tcsh = true,
  dash = true,
  login = true,
}

local tui_apps = {
  nvim = '',
  vim = '',
  vi = '',
  nano = '󰈙',
  yazi = '󰇥',
  ranger = '󰇥',
  lazygit = '󰊢',
  lazydocker = '󰡨',
  lazysql = '󰆼',
  btop = '󰓅',
  htop = '󰓅',
  top = '󰓅',
  w3m = '󰖟',
  lynx = '󰖟',
  less = '󰈙',
  more = '󰈙',
  man = '󰈙',
}

local ai_tools = {
  agy = '󱚣',
  claude = '󰚩',
  copilot = '󰚩',
  gemini = '󰚩',
  aider = '󰚩',
  cursor = '󰚩',
  ollama = '󰚩',
}

-- Per-tab state tracking for loading spinners & completion alerts
local tab_states = {}

local function get_pane_proc_info(pane)
  local full_name = pane.foreground_process_name or ''
  local raw_proc = ''
  if full_name ~= '' then
    raw_proc = full_name:match('([^/\\]+)$') or full_name
    raw_proc = raw_proc:gsub('%.exe$', '')
  end

  -- Clean up version-named binaries (e.g. Claude Code stores executables as ~/.local/share/claude/versions/2.1.296)
  if full_name:find('/claude/') or full_name:find('/claude$') or full_name:find('claude') then
    raw_proc = 'claude'
  elseif full_name:find('/agy/') or full_name:find('/agy$') then
    raw_proc = 'agy'
  elseif full_name:find('/cline/') or full_name:find('/cline$') then
    raw_proc = 'cline'
  elseif raw_proc:match('^v?%d+%.%d+') then
    -- Fallback: If executable name is purely numbers (e.g. 2.1.296), extract tool name from parent folder
    local tool = full_name:match('/([^/]+)/versions/') or full_name:match('/%.?([^/]+)/bin/')
    if tool and tool ~= '' then
      raw_proc = tool
    end
  end

  local title = pane.title or ''
  title = title:match('^%s*(.-)%s*$') or ''

  local title_first_word = ''
  if not title:find('/') and not title:find('\\') and not title:find('^~') then
    title_first_word = title:match('^(%S+)') or ''
    title_first_word = title_first_word:match('([^/\\]+)$') or title_first_word
  end

  local detected_proc = raw_proc:lower()

  -- Check if title identifies an AI tool or specific CLI command
  if ai_tools[title_first_word:lower()] then
    detected_proc = title_first_word:lower()
  elseif (detected_proc == 'node' or detected_proc == 'python' or detected_proc == 'python3' or detected_proc == 'sh' or detected_proc == 'zsh' or detected_proc == '') and title_first_word ~= '' then
    if not shells[title_first_word:lower()] then
      detected_proc = title_first_word:lower()
    end
  end

  if detected_proc == '' then
    detected_proc = 'shell'
  end

  return detected_proc, title
end

local function get_tab_proc_info(tab)
  local proc, title = get_pane_proc_info(tab.active_pane)
  if not shells[proc] then
    return proc, title
  end

  -- If active split is idle, check if any sibling split in the same tab is running
  if tab.panes then
    for _, p in ipairs(tab.panes) do
      if p.pane_id ~= tab.active_pane.pane_id then
        local other_proc, other_title = get_pane_proc_info(p)
        if not shells[other_proc] and not tui_apps[other_proc] then
          return other_proc, other_title
        end
      end
    end
  end

  return proc, title
end

local function clean_tab_title(tab, custom_title)
  local pane = tab.active_pane
  local title = custom_title or pane.title or ''

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
  -- Garbage collect closed tabs from tab_states
  local active_ids = {}
  for _, t in ipairs(tabs) do
    active_ids[t.tab_id] = true
  end
  for id in pairs(tab_states) do
    if not active_ids[id] then
      tab_states[id] = nil
    end
  end

  local tid = tab.tab_id
  local state = tab_states[tid]
  if not state then
    state = {
      status = 'idle',
      running_proc = nil,
      completed_proc = nil,
      completed_at = 0,
      user_viewed = false,
      viewed_at = 0,
      notified = false,
    }
    tab_states[tid] = state
  end

  local proc, raw_title = get_tab_proc_info(tab)
  local is_shell = shells[proc] == true
  local is_tui = tui_apps[proc] ~= nil

  -- State machine transition
  if is_tui then
    state.status = 'tui'
    state.running_proc = nil
    state.completed_proc = nil
  elseif not is_shell then
    -- A task/agent/command is actively running!
    if state.status ~= 'running' or state.running_proc ~= proc then
      state.status = 'running'
      state.running_proc = proc
      state.completed_proc = nil
      state.completed_at = 0
      state.user_viewed = false
      state.notified = false
    end
  else
    -- Shell prompt is idle
    if state.status == 'running' and state.running_proc then
      -- Transitioned from running -> shell prompt = Task Completed!
      state.status = 'completed'
      state.completed_proc = state.running_proc
      state.running_proc = nil
      state.completed_at = os.time()
      state.user_viewed = tab.is_active
      state.viewed_at = tab.is_active and os.time() or 0
      state.notified = false
    end
  end

  -- Completion highlight expiration logic
  local now = os.time()
  if state.status == 'completed' then
    if tab.is_active then
      if not state.user_viewed then
        state.user_viewed = true
        state.viewed_at = now
      end
      -- User has viewed the completed tab for 6 seconds; reset to idle
      if (now - (state.viewed_at or now)) >= 6 then
        state.status = 'idle'
        state.completed_proc = nil
      end
    else
      -- If in background, stay highlighted until user activates it (or 10min safety timeout)
      if (now - state.completed_at) >= 600 then
        state.status = 'idle'
        state.completed_proc = nil
      end
    end
  end

  local index = tab.tab_index + 1
  local bg = '#16161e'
  local fg = '#565f89'
  local intensity = 'Normal'
  local text = ''

  if state.status == 'completed' then
    -- Prominent emerald highlight: Task Finished!
    bg = '#1f382b'
    fg = '#9ece6a'
    intensity = 'Bold'
    local comp_name = clean_tab_title(tab, state.completed_proc or 'Done')
    text = string.format(' ✔ %d: %s (Done) ', index, comp_name)
  elseif state.status == 'running' then
    -- Animated spinner & loading indicator
    local spinner_char = SPINNER[spinner_idx]
    local run_name = clean_tab_title(tab, state.running_proc or proc)
    text = string.format(' %s %d: %s ', spinner_char, index, run_name)
    if tab.is_active then
      bg = '#1f2335'
      fg = '#7dcfff' -- Electric cyan for active running tab
      intensity = 'Bold'
    else
      bg = '#1c2030'
      fg = '#e0af68' -- Warm amber for background running tab
      intensity = 'Bold'
    end
  elseif is_tui then
    -- Interactive editor/TUI app icon
    local icon = tui_apps[proc] or '󰇥'
    local title = clean_tab_title(tab, proc)
    text = string.format(' %s %d: %s ', icon, index, title)
    if tab.is_active then
      bg = '#24283b'
      fg = '#7aa2f7'
      intensity = 'Bold'
    elseif hover then
      bg = '#1f2335'
      fg = '#c0caf5'
    end
  else
    -- Normal idle shell
    local title = clean_tab_title(tab)
    text = string.format(' %d: %s ', index, title)
    if tab.is_active then
      bg = '#24283b'
      fg = '#7aa2f7'
      intensity = 'Bold'
    elseif hover then
      bg = '#1f2335'
      fg = '#c0caf5'
    end
  end

  return {
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Attribute = { Intensity = intensity } },
    { Text = text },
  }
end)

wezterm.on('update-right-status', function(window, pane)
  -- Advance the spinner animation frame on every periodic tick
  spinner_idx = (spinner_idx % #SPINNER) + 1

  local cells = {}

  -- 1. Modal key table indicator (e.g. RESIZE_PANE)
  local mode = window:active_key_table()
  if mode then
    table.insert(cells, { Background = { Color = '#e0af68' } })
    table.insert(cells, { Foreground = { Color = '#1a1b26' } })
    table.insert(cells, { Attribute = { Intensity = 'Bold' } })
    table.insert(cells, { Text = ' ' .. string.upper(mode) .. ' ' })
  end

  -- 2. Scan tabs for completed alerts and running tasks
  local running_tasks = {}
  local completed_alerts = {}
  local now = os.time()

  local mux_win = window:mux_window()
  if mux_win then
    local tabs = mux_win:tabs_with_info()
    for _, item in ipairs(tabs) do
      local tid = item.tab:tab_id()
      local s = tab_states[tid]
      if s then
        if s.status == 'completed' then
          -- If not yet viewed or recently viewed within 6 seconds
          if not s.user_viewed or (now - (s.viewed_at or now)) < 6 then
            table.insert(completed_alerts, {
              index = item.index + 1,
              proc = s.completed_proc or 'task',
            })
          end
          -- Send desktop notification if completed in the background
          if not s.notified and not item.is_active then
            s.notified = true
            window:toast_notification(
              'Task Completed ✔',
              string.format('Tab %d: "%s" has finished!', item.index + 1, s.completed_proc or 'task'),
              nil,
              4000
            )
          end
        elseif s.status == 'running' and s.running_proc then
          table.insert(running_tasks, {
            index = item.index + 1,
            proc = s.running_proc,
            is_active = item.is_active,
          })
        end
      end
    end
  end

  -- 3. High-Priority Alert Badges
  if #completed_alerts > 0 then
    local alert = completed_alerts[1]
    table.insert(cells, { Background = { Color = '#1f382b' } })
    table.insert(cells, { Foreground = { Color = '#9ece6a' } })
    table.insert(cells, { Attribute = { Intensity = 'Bold' } })
    table.insert(cells, { Text = string.format(' ✔ Tab %d: %s (Done) ', alert.index, alert.proc) })
  elseif #running_tasks > 0 then
    local task = running_tasks[1]
    local spinner_char = SPINNER[spinner_idx]
    table.insert(cells, { Foreground = { Color = '#7dcfff' } })
    table.insert(cells, { Attribute = { Intensity = 'Bold' } })
    if task.is_active then
      table.insert(cells, { Text = string.format(' %s Running: %s ', spinner_char, task.proc) })
    else
      table.insert(cells, { Text = string.format(' %s Tab %d: %s ', spinner_char, task.index, task.proc) })
    end
  end

  -- 4. Rotating Command Hint (concise, updates every 12s)
  local hint_idx = (math.floor(now / 12) % #hints) + 1
  local hint = hints[hint_idx]
  table.insert(cells, { Foreground = { Color = '#e0af68' } })
  table.insert(cells, { Text = ' 💡 ' .. hint.key .. ': ' .. hint.desc .. ' ' })

  -- 5. Workspace badge (shown only when inside a named workspace)
  local workspace = window:active_workspace()
  if workspace and workspace ~= 'default' then
    table.insert(cells, { Foreground = { Color = '#bb9af7' } })
    table.insert(cells, { Text = '  ' .. workspace .. ' ' })
  end

  -- 6. Battery Indicator (for MacBooks)
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

  -- 7. Current Time
  local time = wezterm.strftime('%I:%M %p')
  table.insert(cells, { Foreground = { Color = '#7aa2f7' } })
  table.insert(cells, { Text = ' ' .. time .. ' ' })

  window:set_right_status(wezterm.format(cells))
end)

return config
