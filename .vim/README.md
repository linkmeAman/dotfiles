# 🚀 Modern Vim Setup & Productivity Guide

Welcome to your modernized **Vim 9** setup! This configuration is designed for maximum speed, intuitive ergonomics, modern aesthetics, project-level development, full command discovery, and seamless AI agent workflows.

---

## 💡 1. Suggestions, Hints & Command Discovery

You never need to memorize commands in this setup:

### A. The VS Code-Style Command Palette
* Press **<kbd>Space</kbd> <kbd>p</kbd>** or double-tap **<kbd>Space</kbd> <kbd>Space</kbd>**:
  * An interactive search window opens listing every available command and action.
  * Start typing what you want in plain English (e.g. `format`, `terminal`, `quit`, `git`, `tree`, `undo`, `copilot`, `ai`, `session`, `health`).
  * Press <kbd>Enter</kbd> to run it immediately!

### B. Interactive Dropdown Menu on `:` Commands
* Whenever you type `:` at the bottom (as seen in your screenshot) and begin typing (e.g. `:w`, `:set`, `:Lsp`, `:Copilot`, `:term`), or press <kbd>Tab</kbd>:
  * A vertical popup dropdown (`wildoptions=pum`) appears above the command line showing all matching commands.
  * Cycle through suggestions with <kbd>Tab</kbd>, <kbd>Shift</kbd>+<kbd>Tab</kbd>, or Up/Down arrow keys.

### C. Persistent Status Bar Hints
* The bottom status bar now permanently displays:
  `⌨ <Space>:Menu  <Space>p:Commands  <F1>:Help`
* You will never wonder how to open menus or get help.

### D. Interactive Key Menu (Which-Key)
* Press **<kbd>Space</kbd>** in Normal mode:
  * A floating popup menu instantly appears showing grouped commands:
    `+find`, `+explorer`, `+git`, `+code`, `+windows`, `+buffer`, `+yank`, `+ai-agent`, `+open`, `+settings`.
  * Press the corresponding letter to drill into any category.

### E. Universal Help Shortcut (<kbd>F1</kbd>)
* Press **<kbd>F1</kbd>** or **<kbd>Space</kbd> <kbd>?</kbd>** anytime to open the full in-editor cheatsheet. Press `q` to dismiss.

### F. Code Autocompletion in Insert Mode
* While writing code or editing config files (like YAML, Markdown, Python, etc.), an auto-completion dropdown appears as you type.
* Press <kbd>Tab</kbd> or <kbd>Ctrl</kbd>+<kbd>n</kbd> / <kbd>Ctrl</kbd>+<kbd>p</kbd> to select suggestions.

---

## 🤖 2. AI Agents & Harnesses Launchpad

All major AI coding agents are installed and directly launchable via the `<Space> a` menu:

| Shortcut | Command | Tool / Description |
| :--- | :--- | :--- |
| `<Space> a g` | `:Agy` | **Antigravity AI Agent (`agy`)**: Full autonomous agent with tool execution. |
| `<Space> a c` | `:Claude` | **Anthropic Claude Code (`claude`)**: Anthropic's official terminal coding agent. |
| `<Space> a d` | `:Aider` | **Aider (`aider`)**: AI pair programmer for OpenAI (Codex/GPT-4o), Claude, and DeepSeek. |
| `<Space> a p` | `:PiAgent` | **Pi Coding Agent (`pi`)**: Autonomous AI agent toolkit. |
| `<Space> a o` | `:Ollama` | **Ollama / DeepSeek (`ollama`)**: Run open-weight models locally (`deepseek-r1`, `deepseek-coder`). |
| `<Space> a s` | `:Copilot status` | **GitHub Copilot**: Inline ghost-text AI completions as you type. |
| `<Space> a m` | `:Copilot panel` | **Copilot Multi-Suggestion Panel**: View multiple code completion suggestions. |

---

## 💻 3. VS Code Extensions & Bridge

### Installed in your Visual Studio Code:
* **`vscodevim.vim`**: Full modal Vim editing (motions, surround, sneak) inside native VS Code.
* **`saoudrizwan.claude-dev` (Cline)**: Autonomous AI agent for VS Code.
* **`rooveterinaryinc.roo-cline` (Roo Code)**: Autonomous multi-agent coding extension.
* **`continue.continue`**: Open-source AI copilot supporting DeepSeek, Claude, and Ollama.
* **`github.copilot-chat`**: Built-in Copilot Chat assistant.

### Bridge Commands:
* `<Space> o c` $\rightarrow$ Open current project folder in Visual Studio Code.
* `<Space> o f` $\rightarrow$ Open active file at cursor line in Visual Studio Code.
* `code .` $\rightarrow$ Launch VS Code from terminal.

---

## 📁 4. Opening Folders & Project Workspaces

* **From Terminal:**
  * `v .` $\rightarrow$ Opens current directory. NERDTree automatically opens on the left with your full project tree.
  * `v /path/to/project` $\rightarrow$ Opens any project folder directly.
* **Within Vim:**
  * `<Space> e` $\rightarrow$ Toggle NERDTree sidebar explorer.
  * `<Space> e f` $\rightarrow$ Reveal and locate current file in tree.
  * `<Space> f` $\rightarrow$ Search files across the open folder (`fzf`).
  * `<Space> g` $\rightarrow$ Search project text (`ripgrep`).

---

## ⏪ 5. Backpropagation: Reverting State, Undo & Exiting

Never worry about making mistakes or getting lost:

| Goal | Primary Key | Which-Key Menu | Command (Popup auto-suggest) | Description |
| :--- | :--- | :--- | :--- | :--- |
| **Undo last change** | `u` | `<Space> u u` | `:Undo` | Reverts the last edit step-by-step. |
| **Redo last change** | `<Ctrl-r>` | `<Space> u r` | `:Redo` | Re-applies the undone edit. |
| **Visual Time-Travel Tree** | - | `<Space> u t` | `:UndotreeToggle` | Opens visual branching tree to jump back to any historical point. |
| **Revert file to disk** | - | `<Space> u e` | `:RevertFile` / `:edit!` | Discards all unsaved edits and reloads clean file from disk. |
| **Jump back in cursor history** | `<Ctrl-o>` | `<Space> u o` | `:JumpBack` | "Jump Older": jumps backward to previous line or file. |
| **Jump forward in history** | `<Ctrl-i>` | `<Space> u i` | `:JumpForward` | "Jump Newer": jumps forward along your jump path. |
| **Quit current window** | `:q` | `<Space> q q` | `:q` | Closes active window if saved. |
| **Close split / floating window** | `<Ctrl-w>c` | `<Space> q w` | `:QuitWindow` / `:close` | Closes active split or popup safely without killing Vim. |
| **Force quit window** | `:q!` | `<Space> q f` | `:q!` | Quits active window, discarding unsaved edits. |
| **Force quit everything** | `<Space> Q` | `<Space> q A` | `:ForceQuit` / `:qa!` | Exits Vim/Neovim completely without saving. |
| **Close all other splits** | - | `<Space> q o` | `:CloseAllOthers` / `:only` | Keeps only the active window open, hiding all other splits. |
| **Cancel any prompt / search** | `<Esc>` / `<C-c>` | - | - | Immediately cancels any menu or prompt back to Normal mode. |

---

## 🛠️ Complete Keybindings Cheat Sheet

| Category | Shortcut | Command / Action |
| :--- | :--- | :--- |
| **Discovery & Help** | `<Space> p` / `<Space><Space>` | **Command Palette (Search any command)** |
| | `<F1>` or `<Space> ?` | Open in-editor guide (`:Guide`) |
| | `<Space>` *(pause 0.3s)* | Interactive Which-Key menu |
| | `<Space> s h` | Run system health check (`:VimHealth`) |
| **AI Harnesses** | `<Space> a g` | Launch Antigravity Agent (`:Agy`) |
| | `<Space> a c` | Launch Claude Code (`:Claude`) |
| | `<Space> a d` | Launch Aider Pair Programmer (`:Aider`) |
| | `<Space> a p` | Launch Pi Coding Agent (`:PiAgent`) |
| | `<Space> a o` | Launch Ollama / DeepSeek (`:Ollama`) |
| **VS Code Bridge** | `<Space> o c` | Open current folder in VS Code |
| | `<Space> o f` | Open active file at cursor in VS Code |
| **Terminal Drawer**| `<Space> t` | Toggle bottom terminal drawer |
| **Files & Search** | `<Space> f` / `<C-p>` | Fuzzy find files (`fzf`) |
| | `<Space> g` | Ripgrep project text |
| | `<Space> g w` / `<Space> f w` | **Search word under cursor across project (`:RgWord`)** |
| | `<Space> c o` / `<Space> c s` | **Code outline / symbol search in file (`:BTags`)** |
| | `<Space> e` | Toggle file explorer sidebar (`NERDTree`) |
| **Motions** | `s{char}{char}` | Jump to 2 characters on screen (`vim-sneak`) |
| | `<C-d>` / `<C-u>` | Smooth animated scrolling (`vim-smoothie`) |
| **Editing** | `Alt/Option + j / k` | **Move line or selected block up/down (auto-indented)** |
| | `<` / `>` (visual) | **Continuous indenting (selection stays active)** |
| | `p` (visual) | **Safe paste (preserves clipboard contents!)** |
| | `gcc` / `gc` | Toggle comments (`vim-commentary`) |
| | `ysiw"` / `cs"'` / `ds"` | Surround motions (`vim-surround`) |
| | `<C-n>` | Multi-cursor word selection |
| | `<Space> u` | Visual undo tree (`undotree`) |
| | `<Space> r w` | Search & replace word under cursor |
| | `<Space> c f` | Format code via LSP or auto-indent |
| | `<Space> y p` / `y r` / `y n` | Copy full path / relative path / file name |
| **Splits & Windows**| `<Space> z` | **Toggle Zoom active split (maximize window / restore)** |
| | `<Ctrl-h/j/k/l>` | Move to left / down / up / right window |
| | `<Space> v s` / `v v` | Split horizontally / vertically |
| | `<Space> v c` | Close active window |
| **Buffers & Tabs** | Top Tab Bar | **Shows all open files across top of screen** |
| | `Shift-L` / `Shift-H` | Next / previous buffer tab |
| | `<Space> b s` | **Open disposable scratchpad (`:Scratch`)** |
| | `<Space> b d` | Close active buffer |
| **Git** | `<Space> g s` | Interactive Git dashboard (`:Git`) |
| | `]c` / `[c` | Jump to next / previous diff hunk |
| | `<Space> g p` | Preview diff hunk at cursor |
| **Workspace** | `<Space> s s` / `s r` | Save / restore session |
| | `<Space> s v` | Reload `~/.vimrc` |
| | `<Space> w` / `q` | Save file / Quit |

---

## 🆘 Troubleshooting: Getting Unstuck

| Situation | Immediate Fix |
| :--- | :--- |
| **Stuck in FZF / Ripgrep (`modifiable is off`)** | Press `<Esc>` (or type `:close` followed by `<Enter>`) to immediately dismiss the floating window. |
| **Stuck in Terminal Drawer / AI Agent** | Press `<Esc>` to enter Terminal-Normal mode, then `<Space> v c` or `:close` to hide the drawer. |
| **Vim says `No write since last change`** | Save with `:w` (or `<Space> w`), or force quit without saving with `:q!` / `<Space> Q`. |
| **Command menu didn't appear** | Press `<Space>` and wait 0.3 seconds; Which-Key displays all available keys. |
| **Lost or confused about layout** | Type `:only` (`<Space> v o`) to close all splits except your current file. |
