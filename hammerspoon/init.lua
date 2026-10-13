-- ==============================================================================
--                     HAMMERSPOON INIT — Keyboard-First macOS
-- ==============================================================================
-- Option+Space  : Quake/dropdown WezTerm toggle (full-width, top half of screen)
-- Ctrl+Option+1 : Focus / open WezTerm (workspace 1)
-- Ctrl+Option+2 : Focus / open browser (workspace 2)
-- Ctrl+Option+5 : Focus / open Slack (workspace 5)
-- Option+Escape : Lock screen instantly
-- ==============================================================================

-- ---------------------------------------------------------------------------
-- 1. WezTerm Quake / Dropdown Toggle  (Option+Space)
-- ---------------------------------------------------------------------------
local wezterm_quake_visible = false
local QUAKE_HEIGHT_RATIO = 0.50   -- 50 % of screen height
local QUAKE_OPACITY      = 0.97

local function quake_toggle()
  local app = hs.application.get('WezTerm')

  -- Launch if not running at all
  if not app then
    hs.application.launchOrFocus('WezTerm')
    hs.timer.doAfter(0.6, function()
      local a = hs.application.get('WezTerm')
      if a then
        local screen = hs.screen.mainScreen()
        local f      = screen:fullFrame()
        local win    = a:focusedWindow()
        if win then
          win:setFrame({
            x = f.x,
            y = f.y,
            w = f.w,
            h = math.floor(f.h * QUAKE_HEIGHT_RATIO),
          })
          win:focus()
        end
      end
    end)
    wezterm_quake_visible = true
    return
  end

  local win = app:focusedWindow() or app:mainWindow()

  if wezterm_quake_visible and app:isFrontmost() then
    -- Hide it
    app:hide()
    wezterm_quake_visible = false
  else
    -- Position at top of screen, full-width, and show
    local screen = hs.screen.mainScreen()
    local f      = screen:fullFrame()
    if win then
      win:setFrame({
        x = f.x,
        y = f.y,
        w = f.w,
        h = math.floor(f.h * QUAKE_HEIGHT_RATIO),
      })
    end
    app:activate()
    if win then win:focus() end
    wezterm_quake_visible = true
  end
end

hs.hotkey.bind({ 'option' }, 'space', quake_toggle)

-- ---------------------------------------------------------------------------
-- 2. App Focus Shortcuts (Ctrl+Option+<number>)
-- ---------------------------------------------------------------------------
local function focusOrLaunch(appName)
  return function()
    local app = hs.application.get(appName)
    if app and app:isFrontmost() then
      app:hide()
    else
      hs.application.launchOrFocus(appName)
    end
  end
end

hs.hotkey.bind({ 'ctrl', 'option' }, '1', focusOrLaunch('WezTerm'))
hs.hotkey.bind({ 'ctrl', 'option' }, '2', focusOrLaunch('Firefox'))
hs.hotkey.bind({ 'ctrl', 'option' }, '3', focusOrLaunch('Google Chrome'))
hs.hotkey.bind({ 'ctrl', 'option' }, '5', focusOrLaunch('Slack'))
hs.hotkey.bind({ 'ctrl', 'option' }, '9', focusOrLaunch('Mail'))

-- ---------------------------------------------------------------------------
-- 3. Instant Screen Lock  (Option+Escape)
-- ---------------------------------------------------------------------------
hs.hotkey.bind({ 'option' }, 'escape', function()
  hs.caffeinate.lockScreen()
end)

-- ---------------------------------------------------------------------------
-- 4. Clipboard History  (Ctrl+Option+V → fuzzy-pick from last 20 clips)
-- ---------------------------------------------------------------------------
local clipboard_history = {}
local MAX_CLIPS = 20

local clipboard_watcher = hs.pasteboard.watcher.new(function(v)
  if v and v ~= '' and v ~= clipboard_history[1] then
    table.insert(clipboard_history, 1, v)
    if #clipboard_history > MAX_CLIPS then
      table.remove(clipboard_history)
    end
  end
end)
clipboard_watcher:start()

hs.hotkey.bind({ 'ctrl', 'option' }, 'v', function()
  if #clipboard_history == 0 then
    hs.alert.show('Clipboard history is empty')
    return
  end
  local choices = {}
  for i, clip in ipairs(clipboard_history) do
    local preview = clip:sub(1, 80):gsub('\n', '↵')
    table.insert(choices, { text = preview, subText = string.format('#%d  (%d chars)', i, #clip), index = i })
  end
  local chooser = hs.chooser.new(function(choice)
    if choice then
      hs.pasteboard.setContents(clipboard_history[choice.index])
      hs.eventtap.keyStroke({ 'cmd' }, 'v')
    end
  end)
  chooser:choices(choices)
  chooser:searchSubText(true)
  chooser:show()
end)

-- ---------------------------------------------------------------------------
-- 5. Window snap to halves / quarters  (Ctrl+Option + Arrow)
-- ---------------------------------------------------------------------------
local function snap(x_frac, y_frac, w_frac, h_frac)
  return function()
    local win    = hs.window.focusedWindow()
    local screen = win:screen()
    local f      = screen:frame()
    win:setFrame({
      x = f.x + f.w * x_frac,
      y = f.y + f.h * y_frac,
      w = f.w * w_frac,
      h = f.h * h_frac,
    })
  end
end

hs.hotkey.bind({ 'ctrl', 'option' }, 'left',  snap(0,   0,   0.5, 1  ))  -- Left half
hs.hotkey.bind({ 'ctrl', 'option' }, 'right', snap(0.5, 0,   0.5, 1  ))  -- Right half
hs.hotkey.bind({ 'ctrl', 'option' }, 'up',    snap(0,   0,   1,   0.5))  -- Top half
hs.hotkey.bind({ 'ctrl', 'option' }, 'down',  snap(0,   0.5, 1,   0.5))  -- Bottom half
hs.hotkey.bind({ 'ctrl', 'option' }, 'return',function()                  -- Maximize
  local win = hs.window.focusedWindow()
  win:maximize()
end)

-- ---------------------------------------------------------------------------
-- 6. Config auto-reload on save
-- ---------------------------------------------------------------------------
local function reload_config(files)
  local do_reload = false
  for _, f in pairs(files) do
    if f:sub(-4) == '.lua' then do_reload = true end
  end
  if do_reload then hs.reload() end
end

local hs_watcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reload_config)
hs_watcher:start()
hs.alert.show('✅ Hammerspoon loaded  (Option+Space: WezTerm quake)', 2)
