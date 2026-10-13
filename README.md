# ⚡ Dotfiles: Modern Developer Environment (Zsh, WezTerm & Vim)

A high-performance, aesthetic, and fully calibrated development environment for **macOS** and **Linux**.

---

## 🚀 One-Line Installation (Fresh System)

On any new Mac or Linux machine, clone this repository and run the setup script:

```bash
git clone https://github.com/linkmeAman/dotfiles.git ~/dotfiles && bash ~/dotfiles/install.sh
```

The script will automatically:
- Install Homebrew (if missing on macOS)
- Install core CLI tools: `fzf`, `ripgrep`, `bat`, `eza`, `tlrc` (`tldr`)
- Install **WezTerm** via Homebrew Cask
- Install **Oh My Zsh** & required community plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`)
- Link all configuration files (`~/.zshrc`, `~/.wezterm.lua`, `~/.vimrc`, custom theme, aliases, functions, options)
- Bootstrap Vim plugins via `vim-plug`
- Pre-cache 7,500+ offline `tldr` cheatsheets

---

## 🖥️ 1. WezTerm Terminal Emulator (`wezterm.lua`)

A GPU-accelerated terminal emulator configured for Apple Silicon and modern high-DPI displays.

### Key Capabilities:
* **Dynamic Theme Switching**: Automatically switches between **Tokyo Night** (Dark) and **Tokyo Night Day** (Light) matching your macOS system appearance.
* **Apple Silicon ProMotion**: Configured for buttery-smooth **120Hz** rendering (`max_fps = 120`).
* **Modern Typography**: JetBrains Mono with coding ligatures enabled (`calt`, `clig`, `liga`, `zero`).
* **macOS Window Aesthetics**: Integrated traffic-light window controls, 0.95 opacity, 30 blur, and custom padding.
* **Smart Inactive Panes**: Inactive split panes subtly dim to maintain visual focus on the active buffer.

### Essential WezTerm Shortcuts (Zero-Touchpad Navigation):
| Action | Shortcut (macOS) | Description |
| :--- | :--- | :--- |
| **Open Link (No Mouse)** | <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>E</kbd> | Displays letter badge over every URL; type letters to open in browser |
| **Fuzzy Tab Search** | <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>T</kbd> | Fuzzy search and switch open tabs by name without touching mouse |
| **Vim Pane Jump** | <kbd>Cmd</kbd> + <kbd>Option</kbd> + <kbd>H/J/K/L</kbd> | Instant home-row pane navigation (left, down, up, right) |
| **Split Pane (Right)** | <kbd>Cmd</kbd> + <kbd>D</kbd> | Split current pane side-by-side |
| **Split Pane (Down)** | <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>D</kbd> | Split current pane top/bottom (35% height drawer) |
| **Scratchpad Drawer** | <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>I</kbd> | Instant bottom terminal drawer |
| **Zoom Active Pane** | <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>Z</kbd> | Maximize active pane to full window (toggle) |
| **Modal Resize Mode** | <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>R</kbd> | Resize panes with arrow keys or `h/j/k/l` (`Enter`/`Esc` to exit) |
| **File Manager (Yazi)** | <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>Y</kbd> | Launch Yazi terminal file manager in new tab |
| **Code Editor (Neovim)** | <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>V</kbd> | Launch Neovim in new tab |
| **Git UI (Lazygit)** | <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>G</kbd> | Launch Lazygit in new tab |
| **Docker UI (Lazydocker)**| <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>K</kbd> | Launch Lazydocker in new tab |
| **Database UI (Lazysql)** | <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>U</kbd> | Launch Lazysql in new tab |
| **System Monitor (Btop)** | <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>B</kbd> | Launch Btop real-time monitor in new tab |
| **Project Workspaces** | <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>O</kbd> | Fuzzy search Git repos and spawn dedicated workspace |
| **Command Palette** | <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd> | Search all WezTerm actions interactively |
| **Hints Guide** | <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>H</kbd> | Interactive search of all configured hotkeys |
| **Keyboard Scrollback** | <kbd>Shift</kbd> + <kbd>PageUp/Down</kbd> | Scroll half-page through output without trackpad |
| **Prompt Jump** | <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>↑ / ↓</kbd> | Jump directly between previous command prompts |
| **QuickSelect** | <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>Space</kbd> | Hit overlay letters to copy URLs, Git hashes, IPs, or UUIDs |
| **Vi Copy Mode** | <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>X</kbd> | Full Vi navigation: `h/j/k/l`, `/` search, `v` select, `y` yank |
| **Direct Tab Jump** | <kbd>Cmd</kbd> + <kbd>1</kbd> - <kbd>9</kbd> | Switch directly to tabs 1 through 9 |

---

## 📝 2. Modern Vim 9 IDE & AI Launchpad (`vimrc`)

A complete modal IDE configured with pure Vimscript for instantaneous startup, project-level workflows, and seamless AI agent execution.

* **Leader Key**: <kbd>Space</kbd>
* **Interactive Cheatsheet**: Press `<Space> ?` or run `:Guide` inside Vim to view the live in-editor cheat sheet.
* **Auto-Bootstrapping**: Downloads `vim-plug` and synchronizes all plugins on first launch.

### 🤖 Built-In AI Coding Agents Launchpad:
Launch any installed autonomous AI coding agent directly inside an integrated Vim terminal drawer:

| Shortcut | Command | Agent / Description |
| :--- | :--- | :--- |
| `<Space> a g` | `:Agy` | **Antigravity AI Agent (`agy`)**: Autonomous coding agent with tool execution. |
| `<Space> a c` | `:Claude` | **Claude Code (`claude`)**: Anthropic's official terminal coding agent. |
| `<Space> a d` | `:Aider` | **Aider (`aider`)**: AI pair programmer with multi-model support. |
| `<Space> a p` | `:PiAgent` | **Pi Coding Agent (`pi`)**: Autonomous agent toolkit. |
| `<Space> a o` | `:Ollama` | **Ollama / DeepSeek (`ollama`)**: Local open-weight coding LLMs. |
| `<Space> a s` | `:Copilot status` | **GitHub Copilot**: Inline ghost-text AI completions (<kbd>Tab</kbd> to accept). |
| `<Space> a m` | `:Copilot panel` | **Copilot Panel**: View multiple code completion suggestions. |

### 📁 Project Explorer & Search:
* `v .` $\rightarrow$ Open current folder from terminal with NERDTree automatically focused on the left.
* `<Space> e` / <kbd>Ctrl</kbd> + <kbd>N</kbd> $\rightarrow$ Toggle NERDTree file explorer sidebar.
* `<Space> e f` $\rightarrow$ Reveal and highlight the current file in NERDTree.
* `<Space> f` / <kbd>Ctrl</kbd> + <kbd>P</kbd> $\rightarrow$ Fuzzy file finder across the entire repository (`fzf`).
* `<Space> g` $\rightarrow$ Live full-text search with `ripgrep` across project files.
* `<Space> b` $\rightarrow$ Interactive open buffers switcher.

### 🌉 VS Code Bridge Commands:
* `<Space> o c` $\rightarrow$ Open current project folder in Visual Studio Code.
* `<Space> o f` $\rightarrow$ Open active file at exact cursor line in Visual Studio Code.

---

## 🎨 3. Aesthetic `devpro` Prompt Bar

Connected rounded-tree prompt that displays path, git status, live timestamp, and command execution timer without overflowing:

```text
╭─ ~/Projects/my-app git:(main ✔) [2026-10-12 16:00:00] ⏱ 1.4s
╰─❯ 
```
*(If a command fails, turns red: `╰─✖ 1 ❯`)*

- **Bold Path**: Always shows full directory relative to home (`~`)
- **Git Realtime**: Branch name, clean (`✔`), or dirty (`✗`)
- **Execution Timer**: Automatically times any command taking >1.0s (e.g. `npm build`, `cargo run`)
- **No Line Overflow**: 2-line layout keeps typed commands clean and un-truncated

---

## 🛠️ 4. Supercharged CLI Tools & Shortcuts

### 🧠 Command Understanding & Learning
* **`tldr <cmd>`** — Concise, practical real-world command usage (e.g., `tldr tar`, `tldr curl`).
* **`explain '<cmd>'`** — Opens [explainshell.com](https://explainshell.com) to visually dissect every argument and flag.
* **`why <alias_or_cmd>`** — Reveals the underlying code/definition of any command or alias.
* **`cheat <cmd>`** — Instant cheatsheet lookup from cheat.sh.

### ⚡ Modern File Tools (`bat` & `eza`)
* **`cat <file>` / `preview <file>`** — Syntax-highlighted code viewer with line numbers and Git modifications.
* **`l` / `ll`** — Fast, colorful directory listing with file icons and Git status indicators.
* **`lt`** — 2-level directory tree view with file icons.

### 🔍 Fuzzy Finder (`fzf` + `ripgrep`)
* **<kbd>Ctrl</kbd> + <kbd>R</kbd>** — Interactive fuzzy search through entire command history.
* **<kbd>Ctrl</kbd> + <kbd>T</kbd>** — Fuzzy file finder with **live syntax-highlighted preview pane** (`bat`).
* **<kbd>Alt/Option</kbd> + <kbd>C</kbd>** — Fuzzy folder switcher with **live tree preview pane** (`eza`).
* **`**<Tab>`** — Fuzzy argument completion (e.g. `cd **<Tab>`, `kill **<Tab>`).

### ⏩ Typing Speed & Quality of Life
* **Autosuggestion Word-by-Word**: Press <kbd>Option</kbd> + <kbd>→</kbd> to accept ghost text word-by-word.
* **Autosuggestion Full Accept**: Press <kbd>→</kbd> or <kbd>Ctrl</kbd> + <kbd>Space</kbd> / <kbd>Ctrl</kbd> + <kbd>F</kbd>.
* **Typo Correction (`CORRECT`)**: Suggests corrections for mistyped commands before failing.
* **Global Pipe Shortcuts**:
  - `... G <query>` ➔ `| grep -i <query>`
  - `... C` ➔ `| pbcopy` *(copies output to Mac clipboard)*
  - `... H` / `... T` ➔ `| head -n 20` / `| tail -n 20`
  - `... L` / `... W` ➔ `| less` / `| wc -l`

### 🖼️ Media (Photo & Video) Viewers & Path Copiers
* **`pic <image>`** — View image in high-resolution inside WezTerm (`viu`/`chafa`) and automatically copy its absolute path to clipboard.
* **`fpic`** — Interactive fuzzy finder for all images with live terminal image rendering previews!
* **`vid <video>`** — Play video with keyboard-driven `mpv`, inspect metadata (`ffprobe`), and copy path to clipboard.
* **`fvid`** — Interactive fuzzy finder for all video files in current folder/project.

### 🌐 Terminal CLI Web Browsers (`w3m` & `lynx`)
* **`browse <url>` / `web <url>`** — Open and navigate websites directly in terminal (`w3m` with vim `j/k` navigation, `Tab` link jump, `B` back, `q` quit).
* **`google <query>`** — Search Google and read results directly in the terminal without opening Chrome or Safari.
* **`duck <query>`** — Search DuckDuckGo directly in the terminal.

### 🧰 Developer Helper Functions
* **`kp`** — Interactive fuzzy process killer (<kbd>Tab</kbd> to multi-select, <kbd>Enter</kbd> to kill stuck port/server).
* **`fco`** — Interactive git branch switcher.
* **`fif <query>`** — Search text across entire codebase with live syntax preview and editor line jump.
* **`killport <port>`** — Kill whatever process is occupying a port (e.g. `killport 3000`).
* **`serve [port]`** — Start an instant local HTTP web server in current directory.
* **`up [n]`** — Navigate up `n` directories at once (`up 3` = `cd ../../..`).
* **`mkcd <dir>`** — Create directory and immediately cd into it.
* **`cdtemp`** — Jump into a fresh scratch directory in `/tmp`.
* **`groot`** — Jump straight to the Git repository root.
* **`glog`** — Color-coded ASCII Git graph log.
* **`gundo`** — Safely undo the last commit while keeping files staged.
* **`nah`** — Discard all local uncommitted changes and clean untracked files.
* **`json <string|file>`** — Format and prettify JSON with interactive `jless`.
* **`disk [path]`** — Visual disk space analyzer with `dust`.
* **`myip`** — Show both LAN IP and public WAN IP.
* **`help` / `zhelp`** — Interactive in-terminal cheatsheet dashboard.

---

## 📁 Repository Structure

```text
dotfiles/
├── .gitignore
├── README.md                      # Comprehensive documentation & shortcuts
├── install.sh                     # Automated one-step setup script
├── zshrc                          # Calibrated ~/.zshrc configuration
├── wezterm.lua                    # GPU-accelerated terminal emulator configuration
├── vimrc                          # Modern Vim 9 IDE & AI agent launchpad
├── bin/
│   └── wz                         # WezTerm developer companion CLI utility
├── .vim/                          # Vim documentation & guides
│   ├── GUIDE.txt                  # In-editor interactive cheatsheet (:Guide)
│   └── README.md                  # Comprehensive Vim workflow guide
└── custom/
    ├── aliases.zsh                # Modern shortcuts & global pipes
    ├── dev_options.zsh            # FZF previews, autosuggestions, history
    ├── functions.zsh              # Developer helper functions & help dashboard
    └── themes/
        └── devpro.zsh-theme       # Connected aesthetic prompt bar
```
